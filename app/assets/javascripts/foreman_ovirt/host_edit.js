$(document).ready(function() {
  var ovirt = {
    update_cluster_tab: function (compute_resource_id) {
      if (compute_resource_id) {
        $('#cluster-indicator').show();
        $.get('/compute_resources/' + compute_resource_id + '/available_clusters', { 'format': 'json' }, function (data) {
          var cluster_id = $('#host_compute_attributes_cluster_id');
          helpers.update_select_options(cluster_id, data);
          cluster_id.change();
          $('#cluster-indicator').hide();
        });
      } else {
        $('#cluster-indicator').hide();
      }
    },

    update_template_tab: function (compute_resource_id, cluster_id) {
      if (compute_resource_id && cluster_id) {
        $('#template-indicator').show();
        $.get('/compute_resources/' + compute_resource_id + '/available_images', { 'cluster_id': cluster_id, 'format': 'json' }, function (data) {
          var template_id = $('#host_compute_attributes_template_id');
          helpers.update_select_options(template_id, data);
          $('#template-indicator').hide();
        });
      } else {
        $('#template-indicator').hide();
      }
    }
  };

  $('#host_compute_resource_id').on('change', function () {
    var selected = $(this).find('option:selected');
    if (selected.data('provider') === 'Ovirt') {
      ovirt.update_cluster_tab($(this).val());
    }
  });

  $('#host_compute_attributes_cluster_id').on('change', function () {
    var compute_resource_id = $('#host_compute_resource_id').val();
    var selected = $('#host_compute_resource_id').find('option:selected');
    if (selected.data('provider') === 'Ovirt') {
      ovirt.update_template_tab(compute_resource_id, $(this).val());
    }
  });

  if ($('#host_compute_resource_id').find('option:selected').data('provider') === 'Ovirt') {
    ovirt.update_cluster_tab($('#host_compute_resource_id').val());
  }

  $('#host_interfaces_attributes').on('change', '.type', function() {
    var root = $(this).parents('.fields');
    // show the relevant network
    var network = $(this).val();
    if (network) {
      // hide all other networks
      root.find('.ovirt_network').hide();
      // show the relevant network
      root.find('.' + network.toLowerCase() + '_network').show();
    }
  });
});
