import sum from './index.js';

describe('sum function', () => {
  test('should return 0 if a is not a number', () => {
    expect(sum('a', 2)).toBe(0);
  });

  test('should return 0 if b is not a number', () => {
    expect(sum(1, 'b')).toBe(0);
  });

  test('should return 0 if both a and b are not numbers', () => {
    expect(sum('a', 'b')).toBe(0);
  });

  test('should return 0 if a is negative', () => {
    expect(sum(-1, 2)).toBe(0);
  });

  test('should return 0 if b is negative', () => {
    expect(sum(1, -2)).toBe(0);
  });

  test('should return 0 if both a and b are negative', () => {
    expect(sum(-1, -2)).toBe(0);
  });

  test('should return the sum if both a and b are positive numbers', () => {
    expect(sum(1, 2)).toBe(3);
  });

  test('should return the sum if a is zero and b is positive', () => {
    expect(sum(0, 5)).toBe(5);
  });

  test('should return the sum if a is positive and b is zero', () => {
    expect(sum(5, 0)).toBe(5);
  });

  test('should return 0 if both a and b are zero (as per non-negative rule, sum is 0)', () => {
    expect(sum(0, 0)).toBe(0);
  });

  test('should handle decimal positive numbers correctly', () => {
    expect(sum(1.5, 2.5)).toBe(4);
  });
});