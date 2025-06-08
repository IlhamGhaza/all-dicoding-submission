function factorial(n) {
  if (n === 0) {
    return 1;
  }

  return n * factorial(n - 1);
}

// Jangan hapus kode di bawah ini!
export default factorial;
