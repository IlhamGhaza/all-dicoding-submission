const STORAGE_KEY = "BOOKSHELF_APPS";
const RENDER_EVENT = "render-book";
let books = [];
let currentEditingBookId = null;

/**
 * Menghasilkan ID unik berdasarkan timestamp.
 * @returns {number} ID unik.
 */
function generateId() {
  return +new Date();
}

/**
 * Membuat objek buku baru.
 * @param {number} id - ID buku.
 * @param {string} title - Judul buku.
 * @param {string} author - Penulis buku.
 * @param {number} year - Tahun terbit buku.
 * @param {boolean} isComplete - Status buku (selesai/belum dibaca).
 * @returns {object} Objek buku.
 */
function createBookObject(id, title, author, year, isComplete) {
  return {
    id,
    title,
    author,
    year: parseInt(year),
    isComplete,
  };
}

/**
 * Mencari buku berdasarkan ID.
 * @param {number} bookId - ID buku yang dicari.
 * @returns {object|null} Objek buku jika ditemukan, atau null.
 */
function findBook(bookId) {
  return books.find((book) => book.id === bookId) || null;
}

/**
 * Mencari indeks buku dalam array berdasarkan ID.
 * @param {number} bookId - ID buku yang dicari.
 * @returns {number} Indeks buku jika ditemukan, atau -1.
 */
function findBookIndex(bookId) {
  return books.findIndex((book) => book.id === bookId);
}

/**
 * Memeriksa apakah browser mendukung localStorage.
 * @returns {boolean} True jika didukung, false jika tidak.
 */
function isStorageExist() {
  if (typeof Storage === "undefined") {
    alert(
      "Browser Anda tidak mendukung local storage. Fitur penyimpanan tidak akan berfungsi."
    );
    return false;
  }
  return true;
}

/**
 * Menyimpan data buku ke localStorage.
 */
function saveData() {
  if (isStorageExist()) {
    const parsed = JSON.stringify(books);
    localStorage.setItem(STORAGE_KEY, parsed);
  }
}

/**
 * Memuat data buku dari localStorage.
 */
function loadDataFromStorage() {
  const serializedData = localStorage.getItem(STORAGE_KEY);
  let data = JSON.parse(serializedData);
  if (data !== null) {
    books = data;
  }
  document.dispatchEvent(new Event(RENDER_EVENT));
}

/**
 * Membuat elemen HTML untuk satu buku.
 * @param {object} bookObject - Objek buku.
 * @returns {HTMLElement} Elemen div yang berisi detail buku.
 */
function makeBookElement(bookObject) {
  const { id, title, author, year, isComplete } = bookObject;

  const textTitle = document.createElement("h3");
  textTitle.innerText = title;
  textTitle.setAttribute("data-testid", "bookItemTitle");

  const textAuthor = document.createElement("p");
  textAuthor.innerText = `Penulis: ${author}`;
  textAuthor.setAttribute("data-testid", "bookItemAuthor");

  const textYear = document.createElement("p");
  textYear.innerText = `Tahun: ${year}`;
  textYear.setAttribute("data-testid", "bookItemYear");

  const actionContainer = document.createElement("div");

  const completeButton = document.createElement("button");
  completeButton.setAttribute("data-testid", "bookItemIsCompleteButton");
  completeButton.innerText = isComplete
    ? "Belum Selesai Dibaca"
    : "Selesai Dibaca";
  completeButton.addEventListener("click", () => toggleBookStatus(id));

  const deleteButton = document.createElement("button");
  deleteButton.setAttribute("data-testid", "bookItemDeleteButton");
  deleteButton.innerText = "Hapus Buku";
  deleteButton.addEventListener("click", () => removeBook(id));

  const editButton = document.createElement("button");
  editButton.setAttribute("data-testid", "bookItemEditButton");
  editButton.innerText = "Edit Buku";
  editButton.addEventListener("click", () => startEditBook(id));

  actionContainer.append(completeButton, deleteButton, editButton);

  const container = document.createElement("div");
  container.setAttribute("data-bookid", id);
  container.setAttribute("data-testid", "bookItem");
  container.append(textTitle, textAuthor, textYear, actionContainer);

  return container;
}

/**
 * Merender semua buku ke rak yang sesuai.
 * @param {array|null} filteredBooks - Opsional, array buku yang sudah difilter untuk ditampilkan.
 */
function renderBooks(filteredBooks = null) {
  const incompleteBookList = document.getElementById("incompleteBookList");
  const completeBookList = document.getElementById("completeBookList");

  incompleteBookList.innerHTML = "";
  completeBookList.innerHTML = "";

  const booksToDisplay = filteredBooks || books;

  for (const bookItem of booksToDisplay) {
    const bookElement = makeBookElement(bookItem);
    if (bookItem.isComplete) {
      completeBookList.append(bookElement);
    } else {
      incompleteBookList.append(bookElement);
    }
  }
}

/**
 * Menambahkan buku baru.
 */
function addBook() {
  const title = document.getElementById("bookFormTitle").value;
  const author = document.getElementById("bookFormAuthor").value;
  const year = document.getElementById("bookFormYear").value;
  const isComplete = document.getElementById("bookFormIsComplete").checked;

  const id = generateId();
  const newBook = createBookObject(id, title, author, year, isComplete);
  books.push(newBook);

  saveData();
  document.dispatchEvent(new Event(RENDER_EVENT));
  resetForm();
}

/**
 * Memperbarui data buku yang sudah ada.
 */
function updateBook() {
  if (!currentEditingBookId) return;

  const bookToUpdate = findBook(currentEditingBookId);
  if (!bookToUpdate) return;

  bookToUpdate.title = document.getElementById("bookFormTitle").value;
  bookToUpdate.author = document.getElementById("bookFormAuthor").value;
  bookToUpdate.year = parseInt(document.getElementById("bookFormYear").value);
  bookToUpdate.isComplete =
    document.getElementById("bookFormIsComplete").checked;

  saveData();
  document.dispatchEvent(new Event(RENDER_EVENT));
  resetForm();
}

/**
 * Mengubah status selesai/belum selesai buku.
 * @param {number} bookId - ID buku yang statusnya akan diubah.
 */
function toggleBookStatus(bookId) {
  const bookTarget = findBook(bookId);
  if (!bookTarget) return;

  bookTarget.isComplete = !bookTarget.isComplete;
  saveData();
  document.dispatchEvent(new Event(RENDER_EVENT));
}

/**
 * Menghapus buku.
 * @param {number} bookId - ID buku yang akan dihapus.
 */
function removeBook(bookId) {
  if (!confirm("Apakah Anda yakin ingin menghapus buku ini?")) return;

  const bookIndex = findBookIndex(bookId);
  if (bookIndex === -1) return;

  books.splice(bookIndex, 1);
  saveData();
  document.dispatchEvent(new Event(RENDER_EVENT));
}

/**
 * Memulai proses edit buku (mengisi form dengan data buku).
 * @param {number} bookId - ID buku yang akan diedit.
 */
function startEditBook(bookId) {
  const bookToEdit = findBook(bookId);
  if (!bookToEdit) return;

  currentEditingBookId = bookId;

  document.getElementById("bookFormTitle").value = bookToEdit.title;
  document.getElementById("bookFormAuthor").value = bookToEdit.author;
  document.getElementById("bookFormYear").value = bookToEdit.year;
  document.getElementById("bookFormIsComplete").checked = bookToEdit.isComplete;

  const submitButton = document.getElementById("bookFormSubmit");
  submitButton.innerHTML = "Simpan Perubahan";
  submitButton.setAttribute("data-mode", "edit");

  document.getElementById("bookForm").scrollIntoView({ behavior: "smooth" });
}

/**
 * Mereset form input buku dan status editing.
 */
function resetForm() {
  document.getElementById("bookFormTitle").value = "";
  document.getElementById("bookFormAuthor").value = "";
  document.getElementById("bookFormYear").value = "";
  const isCompleteCheckbox = document.getElementById("bookFormIsComplete");
  isCompleteCheckbox.checked = false;

  currentEditingBookId = null;

  const submitButton = document.getElementById("bookFormSubmit");

  submitButton.innerHTML =
    "Masukkan Buku ke rak <span>Belum selesai dibaca</span>";
  submitButton.removeAttribute("data-mode");
  updateSubmitButtonSpanText(false);
}

/**
 * Memperbarui teks pada span di dalam tombol submit form buku.
 * @param {boolean} isComplete - Status checkbox "Selesai dibaca".
 */
function updateSubmitButtonSpanText(isComplete) {
  const submitButton = document.getElementById("bookFormSubmit");

  if (submitButton.getAttribute("data-mode") !== "edit") {
    const span = submitButton.querySelector("span");
    if (span) {
      span.innerText = isComplete ? "Selesai dibaca" : "Belum selesai dibaca";
    }
  }
}

/**
 * Mencari buku berdasarkan judul.
 */
function searchBookByTitle() {
  const searchInput = document.getElementById("searchBookTitle");
  const searchTitle = searchInput.value.toLowerCase();

  if (!searchTitle) {
    
    renderBooks(books);
    return;
  }
  const filteredBooks = books.filter((book) =>
    book.title.toLowerCase().includes(searchTitle)
  );
  renderBooks(filteredBooks);

  
  searchInput.scrollIntoView({ behavior: "smooth" });
}

document.addEventListener("DOMContentLoaded", () => {
  const bookForm = document.getElementById("bookForm");
  bookForm.addEventListener("submit", (event) => {
    event.preventDefault();
    if (currentEditingBookId) {
      updateBook();
    } else {
      addBook();
    }
  });

  const searchForm = document.getElementById("searchBook");
  searchForm.addEventListener("submit", (event) => {
    event.preventDefault();
    searchBookByTitle();
  });

  const searchInput = document.getElementById("searchBookTitle");
  searchInput.addEventListener("keyup", () => {
    searchBookByTitle();
  });

  const isCompleteCheckbox = document.getElementById("bookFormIsComplete");
  isCompleteCheckbox.addEventListener("change", function () {
    updateSubmitButtonSpanText(this.checked);
  });

  if (isStorageExist()) {
    loadDataFromStorage();
  }

  updateSubmitButtonSpanText(isCompleteCheckbox.checked);
});

document.addEventListener(RENDER_EVENT, () => {
  renderBooks();
});
