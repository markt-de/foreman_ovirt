import React from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { foremanUrl } from 'foremanReact/common/helpers';
import { useAPI } from 'foremanReact/common/hooks/API/APIHooks';
import ErrorBoundary from 'foremanReact/components/common/ErrorBoundary';
import CardTemplate from 'foremanReact/components/HostDetails/Templates/CardItem/CardTemplate';
import {
  Card,
  CardBody,
  CardHeader,
  CardTitle,
  DescriptionList,
  DescriptionListGroup,
  DescriptionListTerm,
  DescriptionListDescription,
} from '@patternfly/react-core';
import { Spinner } from '@patternfly/react-core';
import { number_to_human_size as NumberToHumanSize } from 'number_helpers';

const OvirtCard = ({ hostDetails }) => {
  const {
    id: hostId,
    compute_resource_id: computeResourceId,
    compute_resource_name: computeResourceName,
    compute_resource_provider: provider,
  } = hostDetails;
  const virtUrl = foremanUrl(`/api/hosts/${hostId}/vm_compute_attributes`);
  const { response: vm, status = {} } = useAPI('get', virtUrl) || {};

  if (status.isLoading) {
    return (
      <CardTemplate header={__('oVirt')}>
        <Spinner size="md" />
      </CardTemplate>
    );
  }

  if (!vm || Object.keys(vm).length === 0) {
    return null;
  }

  const errorFallback = () => (
    <EmptyState
      icon={<div />}
      header={__('Something went wrong')}
      description={__('There was an error loading this content.')}
    />
  );

  return (
    <CardTemplate header={__('oVirt')} masonryLayout>
      <ErrorBoundary fallback={errorFallback}>
        <DescriptionList isCompact isHorizontal>
          <DescriptionListGroup>
            <DescriptionListTerm>{__('Name')}</DescriptionListTerm>
            <DescriptionListDescription>{vm.name}</DescriptionListDescription>
          </DescriptionListGroup>
          <DescriptionListGroup>
            <DescriptionListTerm>{__('Cores per Socket')}</DescriptionListTerm>
            <DescriptionListDescription>{vm.cores}</DescriptionListDescription>
          </DescriptionListGroup>
          <DescriptionListGroup>
            <DescriptionListTerm>{__('Sockets')}</DescriptionListTerm>
            <DescriptionListDescription>{vm.sockets}</DescriptionListDescription>
          </DescriptionListGroup>
          <DescriptionListGroup>
            <DescriptionListTerm>{__('Memory')}</DescriptionListTerm>
            <DescriptionListDescription>
              {NumberToHumanSize(vm.memory, { strip_insignificant_zeros: true })}
            </DescriptionListDescription>
          </DescriptionListGroup>
          {vm.display && (
            <DescriptionListGroup>
              <DescriptionListTerm>{__('Display')}</DescriptionListTerm>
              <DescriptionListDescription>{vm.display.type}</DescriptionListDescription>
            </DescriptionListGroup>
          )}
          {vm.display && vm.display.type === 'vnc' && (
            <DescriptionListGroup>
              <DescriptionListTerm>{__('Keyboard')}</DescriptionListTerm>
              <DescriptionListDescription>
                {vm.display.keyboard_layout}
              </DescriptionListDescription>
            </DescriptionListGroup>
          )}
          {vm.interfaces_attributes && Object.keys(vm.interfaces_attributes).length > 0 &&
            Object.values(vm.interfaces_attributes).map((nic, index) => (
            <DescriptionListGroup key={`nic-${index}`}>
              <DescriptionListTerm>{__('NIC name')}</DescriptionListTerm>
              <DescriptionListDescription>
                {nic.compute_attributes.name}
              </DescriptionListDescription>
              <DescriptionListTerm>{__('Network')}</DescriptionListTerm>
              <DescriptionListDescription>
                {nic.compute_attributes.network}
              </DescriptionListDescription>
              <DescriptionListTerm>{__('MAC address')}</DescriptionListTerm>
              <DescriptionListDescription>{nic.mac}</DescriptionListDescription>
            </DescriptionListGroup>
          ))}
          {vm.volumes_attributes && Object.keys(vm.volumes_attributes).length > 0 &&
            Object.values(vm.volumes_attributes).map((vol, index) => (
            <DescriptionListGroup key={`volume-${index}`}>
              <DescriptionListTerm>{__('Disk')}</DescriptionListTerm>
              <DescriptionListDescription>
                {NumberToHumanSize(vol.size_gb * 1024 ** 3, {
                  strip_insignificant_zeros: true,
                })}
              </DescriptionListDescription>
            </DescriptionListGroup>
          ))}
        </DescriptionList>
      </ErrorBoundary>
    </CardTemplate>
  );
};

OvirtCard.propTypes = {
  hostDetails: PropTypes.shape({
    id: PropTypes.number,
    compute_resource_id: PropTypes.number,
    compute_resource_name: PropTypes.string,
    compute_resource_provider: PropTypes.string,
  }),
};

OvirtCard.defaultProps = {
  hostDetails: {},
};

export default OvirtCard;
