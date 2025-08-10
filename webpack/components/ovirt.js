/* eslint-disable jquery/no-each */
/* eslint-disable jquery/no-text */
/* eslint-disable jquery/no-data */
/* eslint-disable jquery/no-sizzle */
/* eslint-disable jquery/no-hide */
/* eslint-disable jquery/no-attr */
/* eslint-disable jquery/no-ajax */
/* eslint-disable jquery/no-trigger */
/* eslint-disable jquery/no-val */
/* eslint-disable jquery/no-prop */
/* eslint-disable func-names */

import $ from 'jquery';
import { testConnection } from 'foremanReact/components/foreman_compute_resource';

// used by test connection
export function datacenterSelected(item) {
  // eslint-disable-next-line no-undef
  testConnection($('#test_connection_button'));
}
