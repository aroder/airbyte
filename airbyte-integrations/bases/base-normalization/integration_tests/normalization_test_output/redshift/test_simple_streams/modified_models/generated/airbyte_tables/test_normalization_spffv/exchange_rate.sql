{{ config(
    sort = "_airbyte_emitted_at",
    unique_key = '_airbyte_ab_id',
    schema = "test_normalization_spffv",
    post_hook = ["
                    {%
                        set scd_table_relation = adapter.get_relation(
                            database=this.database,
                            schema=this.schema,
                            identifier='exchange_rate_scd'
                        )
                    %}
                    {%
                        if scd_table_relation is not none
                    %}
                    {%
                            do adapter.drop_relation(scd_table_relation)
                    %}
                    {% endif %}
                        "],
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('exchange_rate_ab3') }}
select
    id,
    currency,
    new_column,
    date,
    timestamp_col,
    {{ adapter.quote('hkd@spéçiäl & characters') }},
    nzd,
    usd,
    {{ adapter.quote('column`_\'with""_quotes') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_exchange_rate_hashid
from {{ ref('exchange_rate_ab3') }}
-- exchange_rate from {{ source('test_normalization_spffv', '_airbyte_raw_exchange_rate') }}
where 1 = 1

