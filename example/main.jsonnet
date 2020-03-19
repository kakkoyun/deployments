local obs = (import '../environments/base/observatorium.jsonnet');

local operator = {
  local operator = self,

  config:: {
    name: 'observatorium-cr',
    namespace: obs.config.namespace,

    commonLabels+::
      obs.config.commonLabels {
        name: obs.config.name,
        'app.kubernetes.io/name': operator.config.name,
        'app.kubernetes.io/component': 'observatorium-cr',
      },
  },

  crd:: {
    apiVersion: 'core.observatorium.io/v1alpha1',
    kind: 'Observatorium',
    metadata: operator.config.commonLabels,
    spec: {
      thanosImage: obs.config.thanosImage,
      thanosVersion: obs.config.thanosVersion,
      objectStorageConfig: obs.config.objectStorageConfig,
      hashrings: obs.config.hashrings,

      queryCache: {
        image: obs.config.queryCache.image,
        replicas: obs.config.queryCache.replicas,
        version: obs.config.queryCache.version,
      },
      store: {
        volumeClaimTemplate: obs.config.store.volumeClaimTemplate,
        shards: obs.config.store.shards,
      },
      compact: {
        volumeClaimTemplate: obs.config.compact.volumeClaimTemplate,
        retentionResolutionRaw: obs.config.compact.retentionResolutionRaw,
        retentionResolution5m: obs.config.compact.retentionResolution5m,
        retentionResolution1h: obs.config.compact.retentionResolution1h,
      },
      rule: {
        volumeClaimTemplate: obs.config.rule.volumeClaimTemplate,
      },
      receivers: {
        volumeClaimTemplate: obs.config.receivers.volumeClaimTemplate,
      },
      thanosReceiveController: obs.config.thanosReceiveController {
        hashrings:: null,
      },
      apiGateway: {
        image: obs.config.apiGateway.image,
        version: obs.config.apiGateway.version,
      },
    },
  },

  manifests+:: {
    'observatorium-crd': operator.crd,
  },
};

operator.manifests
