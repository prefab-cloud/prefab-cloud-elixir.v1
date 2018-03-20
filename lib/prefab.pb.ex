defmodule Prefab.ConfigServicePointer do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    account_id:  integer,
    start_at_id: integer
  }
  defstruct [:account_id, :start_at_id]

  field :account_id, 1, type: :int64
  field :start_at_id, 2, type: :int64
end

defmodule Prefab.ConfigDelta do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    id:    integer,
    key:   String.t,
    value: Prefab.ConfigValue.t
  }
  defstruct [:id, :key, :value]

  field :id, 2, type: :int64
  field :key, 3, type: :string
  field :value, 4, type: Prefab.ConfigValue
end

defmodule Prefab.ConfigValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    type:         {atom, any}
  }
  defstruct [:type]

  oneof :type, 0
  field :int, 1, type: :int64, oneof: 0
  field :string, 2, type: :string, oneof: 0
  field :bytes, 3, type: :bytes, oneof: 0
  field :double, 4, type: :double, oneof: 0
  field :bool, 5, type: :bool, oneof: 0
  field :feature_flag, 6, type: Prefab.FeatureFlag, oneof: 0
end

defmodule Prefab.ConfigDeltas do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    deltas: [Prefab.ConfigDelta.t]
  }
  defstruct [:deltas]

  field :deltas, 1, repeated: true, type: Prefab.ConfigDelta
end

defmodule Prefab.UpsertRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    account_id:   integer,
    config_delta: Prefab.ConfigDelta.t,
    previous_key: String.t
  }
  defstruct [:account_id, :config_delta, :previous_key]

  field :account_id, 1, type: :int64
  field :config_delta, 2, type: Prefab.ConfigDelta
  field :previous_key, 3, type: :string
end

defmodule Prefab.LimitResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    passed:         boolean,
    expires_at:     integer,
    enforced_group: String.t,
    current_bucket: integer,
    policy_group:   String.t,
    policy_name:    integer,
    policy_limit:   integer,
    amount:         integer,
    limit_reset_at: integer,
    safety_level:   integer
  }
  defstruct [:passed, :expires_at, :enforced_group, :current_bucket, :policy_group, :policy_name, :policy_limit, :amount, :limit_reset_at, :safety_level]

  field :passed, 1, type: :bool
  field :expires_at, 2, type: :int64
  field :enforced_group, 3, type: :string
  field :current_bucket, 4, type: :int64
  field :policy_group, 5, type: :string
  field :policy_name, 6, type: Prefab.LimitResponse.LimitPolicyNames, enum: true
  field :policy_limit, 7, type: :int32
  field :amount, 8, type: :int64
  field :limit_reset_at, 9, type: :int64
  field :safety_level, 10, type: Prefab.LimitDefinition.SafetyLevel, enum: true
end

defmodule Prefab.LimitResponse.LimitPolicyNames do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field :NOT_SET, 0
  field :SECONDLY_ROLLING, 1
  field :MINUTELY_ROLLING, 3
  field :HOURLY_ROLLING, 5
  field :DAILY_ROLLING, 7
  field :MONTHLY_ROLLING, 8
  field :INFINITE, 9
  field :YEARLY_ROLLING, 10
end

defmodule Prefab.LimitRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    account_id:             integer,
    acquire_amount:         integer,
    groups:                 [String.t],
    limit_combiner:         integer,
    allow_partial_response: boolean
  }
  defstruct [:account_id, :acquire_amount, :groups, :limit_combiner, :allow_partial_response]

  field :account_id, 1, type: :int64
  field :acquire_amount, 2, type: :int32
  field :groups, 3, repeated: true, type: :string
  field :limit_combiner, 4, type: Prefab.LimitRequest.LimitCombiner, enum: true
  field :allow_partial_response, 5, type: :bool
end

defmodule Prefab.LimitRequest.LimitCombiner do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field :NOT_SET, 0
  field :MINIMUM, 1
  field :MAXIMUM, 2
end

defmodule Prefab.FeatureFlag do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    pct:         float,
    whitelisted: [String.t]
  }
  defstruct [:pct, :whitelisted]

  field :pct, 3, type: :double
  field :whitelisted, 4, repeated: true, type: :string
end

defmodule Prefab.LimitDefinition do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    group:         String.t,
    policy_name:   integer,
    limit:         integer,
    burst:         integer,
    account_id:    integer,
    last_modified: integer,
    returnable:    boolean,
    safety_level:  integer
  }
  defstruct [:group, :policy_name, :limit, :burst, :account_id, :last_modified, :returnable, :safety_level]

  field :group, 1, type: :string
  field :policy_name, 2, type: Prefab.LimitResponse.LimitPolicyNames, enum: true
  field :limit, 3, type: :int32
  field :burst, 4, type: :int32
  field :account_id, 5, type: :int64
  field :last_modified, 6, type: :int64
  field :returnable, 7, type: :bool
  field :safety_level, 8, type: Prefab.LimitDefinition.SafetyLevel, enum: true
end

defmodule Prefab.LimitDefinition.SafetyLevel do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field :NOT_SET, 0
  field :L4_BEST_EFFORT, 4
  field :L5_BOMBPROOF, 5
end

defmodule Prefab.LimitDefinitions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    definitions: [Prefab.LimitDefinition.t]
  }
  defstruct [:definitions]

  field :definitions, 1, repeated: true, type: Prefab.LimitDefinition
end

defmodule Prefab.FeatureFlags do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    flags:        [Prefab.FeatureFlag.t],
    cache_expiry: integer
  }
  defstruct [:flags, :cache_expiry]

  field :flags, 1, repeated: true, type: Prefab.FeatureFlag
  field :cache_expiry, 2, type: :int64
end

defmodule Prefab.BufferedRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    account_id:   integer,
    method:       String.t,
    uri:          String.t,
    body:         String.t,
    limit_groups: [String.t],
    content_type: String.t,
    fifo:         boolean
  }
  defstruct [:account_id, :method, :uri, :body, :limit_groups, :content_type, :fifo]

  field :account_id, 1, type: :int64
  field :method, 2, type: :string
  field :uri, 3, type: :string
  field :body, 4, type: :string
  field :limit_groups, 5, repeated: true, type: :string
  field :content_type, 6, type: :string
  field :fifo, 7, type: :bool
end

defmodule Prefab.BatchRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    account_id:      integer,
    method:          String.t,
    uri:             String.t,
    body:            String.t,
    limit_groups:    [String.t],
    batch_template:  String.t,
    batch_separator: String.t
  }
  defstruct [:account_id, :method, :uri, :body, :limit_groups, :batch_template, :batch_separator]

  field :account_id, 1, type: :int64
  field :method, 2, type: :string
  field :uri, 3, type: :string
  field :body, 4, type: :string
  field :limit_groups, 5, repeated: true, type: :string
  field :batch_template, 6, type: :string
  field :batch_separator, 7, type: :string
end

defmodule Prefab.BasicResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
    message: String.t
  }
  defstruct [:message]

  field :message, 1, type: :string
end

defmodule Prefab.OnFailure do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field :NOT_SET, 0
  field :LOG_AND_PASS, 1
  field :LOG_AND_FAIL, 2
  field :THROW, 3
end

defmodule Prefab.RateLimitService.Service do
  @moduledoc false
  use GRPC.Service, name: "prefab.RateLimitService"

  rpc :LimitCheck, Prefab.LimitRequest, Prefab.LimitResponse
  rpc :UpsertLimitDefinition, Prefab.LimitDefinition, Prefab.BasicResponse
end

defmodule Prefab.RateLimitService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Prefab.RateLimitService.Service
end

defmodule Prefab.ConfigService.Service do
  @moduledoc false
  use GRPC.Service, name: "prefab.ConfigService"

  rpc :GetConfig, Prefab.ConfigServicePointer, stream(Prefab.ConfigDeltas)
  rpc :Upsert, Prefab.UpsertRequest, Prefab.ConfigServicePointer
end

defmodule Prefab.ConfigService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Prefab.ConfigService.Service
end

