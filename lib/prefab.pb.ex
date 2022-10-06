defmodule Prefab.LogLevel do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:NOT_SET_LOG_LEVEL, 0)
  field(:TRACE, 1)
  field(:DEBUG, 2)
  field(:INFO, 3)
  field(:WARN, 5)
  field(:ERROR, 6)
  field(:FATAL, 9)
end

defmodule Prefab.OnFailure do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:NOT_SET, 0)
  field(:LOG_AND_PASS, 1)
  field(:LOG_AND_FAIL, 2)
  field(:THROW, 3)
end

defmodule Prefab.LimitResponse.LimitPolicyNames do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:NOT_SET, 0)
  field(:SECONDLY_ROLLING, 1)
  field(:MINUTELY_ROLLING, 3)
  field(:HOURLY_ROLLING, 5)
  field(:DAILY_ROLLING, 7)
  field(:MONTHLY_ROLLING, 8)
  field(:INFINITE, 9)
  field(:YEARLY_ROLLING, 10)
end

defmodule Prefab.LimitRequest.LimitCombiner do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:NOT_SET, 0)
  field(:MINIMUM, 1)
  field(:MAXIMUM, 2)
end

defmodule Prefab.Criteria.CriteriaOperator do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:NOT_SET, 0)
  field(:LOOKUP_KEY_IN, 1)
  field(:LOOKUP_KEY_NOT_IN, 2)
  field(:IN_SEG, 3)
  field(:NOT_IN_SEG, 4)
  field(:ALWAYS_TRUE, 5)
  field(:PROP_IS_ONE_OF, 6)
  field(:PROP_IS_NOT_ONE_OF, 7)
  field(:PROP_ENDS_WITH_ONE_OF, 8)
  field(:PROP_DOES_NOT_END_WITH_ONE_OF, 9)
end

defmodule Prefab.LimitDefinition.SafetyLevel do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:NOT_SET, 0)
  field(:L4_BEST_EFFORT, 4)
  field(:L5_BOMBPROOF, 5)
end

defmodule Prefab.ConfigServicePointer do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:project_id, 1, type: :int64, json_name: "projectId")
  field(:start_at_id, 2, type: :int64, json_name: "startAtId")
  field(:project_env_id, 3, type: :int64, json_name: "projectEnvId")
end

defmodule Prefab.ConfigValue do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  oneof(:type, 0)

  field(:int, 1, type: :int64, oneof: 0)
  field(:string, 2, type: :string, oneof: 0)
  field(:bytes, 3, type: :bytes, oneof: 0)
  field(:double, 4, type: :double, oneof: 0)
  field(:bool, 5, type: :bool, oneof: 0)
  field(:feature_flag, 6, type: Prefab.FeatureFlag, json_name: "featureFlag", oneof: 0)

  field(:limit_definition, 7, type: Prefab.LimitDefinition, json_name: "limitDefinition", oneof: 0)

  field(:segment, 8, type: Prefab.Segment, oneof: 0)
  field(:log_level, 9, type: Prefab.LogLevel, json_name: "logLevel", enum: true, oneof: 0)
end

defmodule Prefab.Configs do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:configs, 1, repeated: true, type: Prefab.Config)

  field(:config_service_pointer, 2,
    type: Prefab.ConfigServicePointer,
    json_name: "configServicePointer"
  )
end

defmodule Prefab.Config do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:id, 1, type: :int64)
  field(:project_id, 2, type: :int64, json_name: "projectId")
  field(:key, 3, type: :string)
  field(:changed_by, 4, type: :string, json_name: "changedBy")
  field(:rows, 5, repeated: true, type: Prefab.ConfigRow)
  field(:variants, 6, repeated: true, type: Prefab.FeatureFlagVariant)
end

defmodule Prefab.ConfigRow do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:project_env_id, 1, type: :int64, json_name: "projectEnvId")
  field(:namespace, 2, type: :string)
  field(:value, 3, type: Prefab.ConfigValue)
end

defmodule Prefab.LimitResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:passed, 1, type: :bool)
  field(:expires_at, 2, type: :int64, json_name: "expiresAt")
  field(:enforced_group, 3, type: :string, json_name: "enforcedGroup")
  field(:current_bucket, 4, type: :int64, json_name: "currentBucket")
  field(:policy_group, 5, type: :string, json_name: "policyGroup")

  field(:policy_name, 6,
    type: Prefab.LimitResponse.LimitPolicyNames,
    json_name: "policyName",
    enum: true
  )

  field(:policy_limit, 7, type: :int32, json_name: "policyLimit")
  field(:amount, 8, type: :int64)
  field(:limit_reset_at, 9, type: :int64, json_name: "limitResetAt")

  field(:safety_level, 10,
    type: Prefab.LimitDefinition.SafetyLevel,
    json_name: "safetyLevel",
    enum: true
  )
end

defmodule Prefab.LimitRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:account_id, 1, type: :int64, json_name: "accountId")
  field(:acquire_amount, 2, type: :int32, json_name: "acquireAmount")
  field(:groups, 3, repeated: true, type: :string)

  field(:limit_combiner, 4,
    type: Prefab.LimitRequest.LimitCombiner,
    json_name: "limitCombiner",
    enum: true
  )

  field(:allow_partial_response, 5, type: :bool, json_name: "allowPartialResponse")

  field(:safety_level, 6,
    type: Prefab.LimitDefinition.SafetyLevel,
    json_name: "safetyLevel",
    enum: true
  )
end

defmodule Prefab.FeatureFlagVariant do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:int, 1, proto3_optional: true, type: :int64)
  field(:string, 2, proto3_optional: true, type: :string)
  field(:double, 3, proto3_optional: true, type: :double)
  field(:bool, 4, proto3_optional: true, type: :bool)
  field(:name, 5, type: :string)
  field(:description, 6, type: :string)
end

defmodule Prefab.Criteria do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:property, 1, type: :string)
  field(:operator, 2, type: Prefab.Criteria.CriteriaOperator, enum: true)
  field(:values, 3, repeated: true, type: :string)
end

defmodule Prefab.Rule do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:criteria, 1, type: Prefab.Criteria)

  field(:variant_weights, 2,
    repeated: true,
    type: Prefab.VariantWeight,
    json_name: "variantWeights"
  )
end

defmodule Prefab.Segment do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:criterion, 1, repeated: true, type: Prefab.Criteria)
end

defmodule Prefab.VariantWeight do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:weight, 1, type: :int32)
  field(:variant_idx, 2, type: :int32, json_name: "variantIdx")
end

defmodule Prefab.FeatureFlag do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:active, 1, type: :bool)
  field(:inactive_variant_idx, 2, type: :int32, json_name: "inactiveVariantIdx")
  field(:rules, 5, repeated: true, type: Prefab.Rule)
end

defmodule Prefab.Identity.AttributesEntry do
  @moduledoc false
  use Protobuf, map: true, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Prefab.Identity do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:lookup, 1, proto3_optional: true, type: :string)
  field(:attributes, 2, repeated: true, type: Prefab.Identity.AttributesEntry, map: true)
end

defmodule Prefab.ClientConfigValue do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:int, 1, proto3_optional: true, type: :int64)
  field(:string, 2, proto3_optional: true, type: :string)
  field(:double, 3, proto3_optional: true, type: :double)
  field(:bool, 4, proto3_optional: true, type: :bool)
end

defmodule Prefab.ConfigEvaluations.ValuesEntry do
  @moduledoc false
  use Protobuf, map: true, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:key, 1, type: :string)
  field(:value, 2, type: Prefab.ClientConfigValue)
end

defmodule Prefab.ConfigEvaluations do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:values, 1, repeated: true, type: Prefab.ConfigEvaluations.ValuesEntry, map: true)
end

defmodule Prefab.LimitDefinition do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:policy_name, 2,
    type: Prefab.LimitResponse.LimitPolicyNames,
    json_name: "policyName",
    enum: true
  )

  field(:limit, 3, type: :int32)
  field(:burst, 4, type: :int32)
  field(:account_id, 5, type: :int64, json_name: "accountId")
  field(:last_modified, 6, type: :int64, json_name: "lastModified")
  field(:returnable, 7, type: :bool)

  field(:safety_level, 8,
    type: Prefab.LimitDefinition.SafetyLevel,
    json_name: "safetyLevel",
    enum: true
  )
end

defmodule Prefab.LimitDefinitions do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:definitions, 1, repeated: true, type: Prefab.LimitDefinition)
end

defmodule Prefab.BufferedRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:account_id, 1, type: :int64, json_name: "accountId")
  field(:method, 2, type: :string)
  field(:uri, 3, type: :string)
  field(:body, 4, type: :string)
  field(:limit_groups, 5, repeated: true, type: :string, json_name: "limitGroups")
  field(:content_type, 6, type: :string, json_name: "contentType")
  field(:fifo, 7, type: :bool)
end

defmodule Prefab.BatchRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:account_id, 1, type: :int64, json_name: "accountId")
  field(:method, 2, type: :string)
  field(:uri, 3, type: :string)
  field(:body, 4, type: :string)
  field(:limit_groups, 5, repeated: true, type: :string, json_name: "limitGroups")
  field(:batch_template, 6, type: :string, json_name: "batchTemplate")
  field(:batch_separator, 7, type: :string, json_name: "batchSeparator")
end

defmodule Prefab.BasicResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:message, 1, type: :string)
end

defmodule Prefab.CreationResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:message, 1, type: :string)
  field(:new_id, 2, type: :int64, json_name: "newId")
end

defmodule Prefab.IdBlock do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:project_id, 1, type: :int64, json_name: "projectId")
  field(:project_env_id, 2, type: :int64, json_name: "projectEnvId")
  field(:sequence_name, 3, type: :string, json_name: "sequenceName")
  field(:start, 4, type: :int64)
  field(:end, 5, type: :int64)
end

defmodule Prefab.IdBlockRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field(:project_id, 1, type: :int64, json_name: "projectId")
  field(:project_env_id, 2, type: :int64, json_name: "projectEnvId")
  field(:sequence_name, 3, type: :string, json_name: "sequenceName")
  field(:size, 4, type: :int64)
end

defmodule Prefab.RateLimitService.Service do
  @moduledoc false
  use GRPC.Service, name: "prefab.RateLimitService", protoc_gen_elixir_version: "0.11.0"

  rpc(:LimitCheck, Prefab.LimitRequest, Prefab.LimitResponse)
end

defmodule Prefab.RateLimitService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Prefab.RateLimitService.Service
end

defmodule Prefab.ConfigService.Service do
  @moduledoc false
  use GRPC.Service, name: "prefab.ConfigService", protoc_gen_elixir_version: "0.11.0"

  rpc(:GetConfig, Prefab.ConfigServicePointer, stream(Prefab.Configs))

  rpc(:GetAllConfig, Prefab.ConfigServicePointer, Prefab.Configs)

  rpc(:Upsert, Prefab.Config, Prefab.CreationResponse)
end

defmodule Prefab.ConfigService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Prefab.ConfigService.Service
end

defmodule Prefab.IdService.Service do
  @moduledoc false
  use GRPC.Service, name: "prefab.IdService", protoc_gen_elixir_version: "0.11.0"

  rpc(:GetBlock, Prefab.IdBlockRequest, Prefab.IdBlock)
end

defmodule Prefab.IdService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Prefab.IdService.Service
end

defmodule Prefab.ClientService.Service do
  @moduledoc false
  use GRPC.Service, name: "prefab.ClientService", protoc_gen_elixir_version: "0.11.0"

  rpc(:GetAll, Prefab.Identity, Prefab.ConfigEvaluations)
end

defmodule Prefab.ClientService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Prefab.ClientService.Service
end

