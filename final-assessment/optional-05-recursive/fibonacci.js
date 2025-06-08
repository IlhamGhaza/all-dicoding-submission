function fibonacci(n) {
  
  if (n === 0) {
    return [0];
  }
  
  if (n === 1) {
    return [0, 1];
  }
  
  const prevSequence = fibonacci(n - 1);
  
  return [...prevSequence, prevSequence[n - 1] + prevSequence[n - 2]];
}

// Jangan hapus kode di bawah ini!
export default fibonacci;
