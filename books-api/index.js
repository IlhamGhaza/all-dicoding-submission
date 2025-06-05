const Hapi = require("@hapi/hapi");

const init = async () => {
  const { nanoid } = await import("nanoid");

  const server = Hapi.server({
    port: 9000,
    host: "localhost",
    routes: {
      cors: {
        origin: ["*"],
      },
    },
  });

  const books = [];

  const generateTimestamp = () => new Date().toISOString();

  const validateBookData = (bookData, action) => {
    // Set default action if not provided
    const actionText = action || "menambahkan";

    if (!bookData.name) {
      return {
        isValid: false,
        message: `Gagal ${actionText} buku. Mohon isi nama buku`,
      };
    }

    if (bookData.readPage > bookData.pageCount) {
      return {
        isValid: false,
        message: `Gagal ${actionText} buku. readPage tidak boleh lebih besar dari pageCount`,
      };
    }

    return { isValid: true };
  };

  server.route({
    method: "POST",
    path: "/books",
    handler: (request, h) => {
      const bookData = request.payload;
      const validation = validateBookData(bookData, "menambahkan");
      if (!validation.isValid) {
        return h
          .response({
            status: "fail",
            message: validation.message,
          })
          .code(400);
      }

      const id = nanoid();
      const timestamp = generateTimestamp();
      const finished = bookData.pageCount === bookData.readPage;

      const newBook = {
        id,
        ...bookData,
        finished,
        insertedAt: timestamp,
        updatedAt: timestamp,
      };

      books.push(newBook);

      return h
        .response({
          status: "success",
          message: "Buku berhasil ditambahkan",
          data: {
            bookId: id,
          },
        })
        .code(201);
    },
  });

  server.route({
    method: "GET",
    path: "/books",
    handler: (request, h) => {
      let filteredBooks = [...books];

      if (request.query.name) {
        const nameFilter = request.query.name.toLowerCase();
        filteredBooks = filteredBooks.filter((book) =>
          book.name.toLowerCase().includes(nameFilter)
        );
      }

      if (request.query.reading !== undefined) {
        const reading = request.query.reading === "1";
        filteredBooks = filteredBooks.filter(
          (book) => book.reading === reading
        );
      }

      if (request.query.finished !== undefined) {
        const finished = request.query.finished === "1";
        filteredBooks = filteredBooks.filter(
          (book) => book.finished === finished
        );
      }

      const simplifiedBooks = filteredBooks.map(({ id, name, publisher }) => ({
        id,
        name,
        publisher,
      }));

      return h
        .response({
          status: "success",
          data: {
            books: simplifiedBooks,
          },
        })
        .code(200);
    },
  });

  server.route({
    method: "GET",
    path: "/books/{bookId}",
    handler: (request, h) => {
      const { bookId } = request.params;
      const book = books.find((b) => b.id === bookId);

      if (!book) {
        return h
          .response({
            status: "fail",
            message: "Buku tidak ditemukan",
          })
          .code(404);
      }

      return h
        .response({
          status: "success",
          data: {
            book,
          },
        })
        .code(200);
    },
  });

  server.route({
    method: "PUT",
    path: "/books/{bookId}",
    handler: (request, h) => {
      const { bookId } = request.params;
      const bookData = request.payload;

      // Explicitly pass "memperbarui" for update validation
      const validation = validateBookData(bookData, "memperbarui");

      if (!validation.isValid) {
        return h
          .response({
            status: "fail",
            message: validation.message,
          })
          .code(400);
      }

      const bookIndex = books.findIndex((b) => b.id === bookId);

      if (bookIndex === -1) {
        return h
          .response({
            status: "fail",
            message: "Gagal memperbarui buku. Id tidak ditemukan",
          })
          .code(404);
      }

      const finished = bookData.pageCount === bookData.readPage;
      const updatedBook = {
        ...books[bookIndex],
        ...bookData,
        finished,
        updatedAt: generateTimestamp(),
      };

      books[bookIndex] = updatedBook;

      return h
        .response({
          status: "success",
          message: "Buku berhasil diperbarui",
        })
        .code(200);
    },
  });

  server.route({
    method: "DELETE",
    path: "/books/{bookId}",
    handler: (request, h) => {
      const { bookId } = request.params;
      const bookIndex = books.findIndex((b) => b.id === bookId);

      if (bookIndex === -1) {
        return h
          .response({
            status: "fail",
            message: "Buku gagal dihapus. Id tidak ditemukan",
          })
          .code(404);
      }

      books.splice(bookIndex, 1);

      return h
        .response({
          status: "success",
          message: "Buku berhasil dihapus",
        })
        .code(200);
    },
  });

  await server.start();
  console.log("Server running on %s", server.info.uri);
};

init();
