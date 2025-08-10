import React from 'react';

import { registerReducer } from 'foremanReact/common/MountingService';
import { addGlobalFill } from 'foremanReact/components/common/Fill/GlobalFill';
import { registerRoutes } from 'foremanReact/routes/RoutingService';

import OvirtCard from './components/extensions/HostDetails/DetailsTabCards/OvirtCard';

addGlobalFill(
  'host-tab-details-cards',
  'oVirt',
  <OvirtCard key="ovirt_card" />,
  25
);
