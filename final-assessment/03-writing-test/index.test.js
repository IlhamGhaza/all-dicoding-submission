import test from 'node:test';
import assert from 'node:assert';
import { sum } from './index.js';

test.describe('Math basic operations', () => {
  test.it('sum function should add two positive numbers correctly', () => {
    assert.strictEqual(sum(1, 2), 3);
  });

  test.it('sum function should add two negative numbers correctly', () => {
    assert.strictEqual(sum(-1, -2), -3);
  });

  test.it('sum function should add a positive and a negative number correctly', () => {
    assert.strictEqual(sum(-1, 2), 1);
  });

  test.it('sum function should add two zeros correctly', () => {
    assert.strictEqual(sum(0, 0), 0);
  });

  test.it('sum function should add a number and zero correctly', () => {
    assert.strictEqual(sum(5, 0), 5);
  });

  test.it('sum function should handle decimal numbers correctly', () => {
    assert.strictEqual(sum(1.5, 2.5), 4);
  });
});