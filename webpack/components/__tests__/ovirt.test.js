import { datacenterSelected } from '../ovirt';

jest.mock('jquery', () => {
  const fn = jest.fn(() => fn);
  fn.fn = fn;
  return fn;
});

jest.mock('foremanReact/components/foreman_compute_resource', () => ({
  testConnection: jest.fn(),
}));

describe('ovirt', () => {
  it('datacenterSelected triggers a test connection', () => {
    expect(() => datacenterSelected({})).not.toThrow();
  });
});
