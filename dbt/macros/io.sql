{#
    Export a model to the prep folder in a CSV format.

    Arguments:
      - relation: the model to be exported.
#}
{% macro export_table(relation) %}

  {% set model_config = get_model_config(relation.identifier) %}
  {{ log(model_config) }}

  {% if model_config.enabled %}
      {% call statement(name, fetch_result=True) %}
        {#
            FORCE_QUOTE * quotes every field, so DuckDB's CSV sniffer always sees a
            quote character and never falls back to quote='' on files where no value
            happens to need quoting. Without it, read_csv_auto breaks on values that
            contain the delimiter (e.g. the player_name 'James Simpson,').
        #}
        COPY {{ relation }} TO '../data/prep/{{ model.name }}.csv.gz' (HEADER, DELIMITER ',', QUOTE '"', FORCE_QUOTE *, COMPRESSION gzip)
      {% endcall %}
  {% else %}
      SELECT 1
  {% endif %}

{% endmacro %}
