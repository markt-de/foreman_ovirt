import React from 'react';

import { addGlobalFill } from 'foremanReact/components/common/Fill/GlobalFill';

import OvirtCard from './components/extensions/HostDetails/DetailsTabCards/OvirtCard';

addGlobalFill(
  'host-tab-details-cards',
  'oVirt',
  <OvirtCard key="ovirt_card" />,
  25
);
