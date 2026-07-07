import { datacenterSelected } from '../ovirt';

jest.mock('jquery', () => {
  const fn = jest.fn(() => fn);
  fn.fn = fn;
  return fn;
});

jest.mock('../ovirt', () => ({
  datacenterSelected: jest.fn(),
}));

describe('ovirt', () => {
  it('datacenterSelected is defined', () => {
    expect(datacenterSelected).toBeDefined();
  });
});
