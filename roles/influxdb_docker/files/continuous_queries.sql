CREATE CONTINUOUS QUERY sp_idp_pa_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.sp_idp_pa_users_day FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, idp_entity_id, year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY idp_pa_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.idp_pa_users_day FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY idp_entity_id, year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY sp_pa_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.sp_pa_users_day FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY total_pa_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.total_pa_users_day FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY sp_idp_ta_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.sp_idp_ta_users_day FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, idp_entity_id, year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY idp_ta_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.idp_ta_users_day FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY idp_entity_id, year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY sp_ta_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.sp_ta_users_day FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY total_ta_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.total_ta_users_day FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY sp_idp_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.sp_idp_users_day FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, idp_entity_id, year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY idp_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.idp_users_day FROM log_logins.autogen.EBAUTH GROUP BY idp_entity_id, year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY sp_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.sp_users_day FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY total_users_day_cq ON log_logins RESAMPLE EVERY 1h FOR 2d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id, count(user_id) AS count_user_id INTO log_logins.autogen.total_users_day FROM log_logins.autogen.EBAUTH GROUP BY year, month, quarter, time(1d) END;

CREATE CONTINUOUS QUERY sp_idp_pa_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_pa_users_month_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY idp_pa_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_pa_users_month_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_pa_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_pa_users_month_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY total_pa_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_pa_users_month_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_idp_ta_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_ta_users_month_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY idp_ta_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_ta_users_month_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_ta_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_ta_users_month_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY total_ta_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_ta_users_month_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_idp_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_users_month_unique FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY idp_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_users_month_unique FROM log_logins.autogen.EBAUTH GROUP BY idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_users_month_unique FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY total_users_month_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_users_month_unique FROM log_logins.autogen.EBAUTH GROUP BY time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_idp_pa_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_pa_users_quarter_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY idp_pa_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_pa_users_quarter_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_pa_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_pa_users_quarter_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY total_pa_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_pa_users_quarter_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_idp_ta_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_ta_users_quarter_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY idp_ta_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_ta_users_quarter_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_ta_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_ta_users_quarter_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY total_ta_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_ta_users_quarter_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_idp_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_users_quarter_unique FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY idp_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_users_quarter_unique FROM log_logins.autogen.EBAUTH GROUP BY idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_users_quarter_unique FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY total_users_quarter_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_users_quarter_unique FROM log_logins.autogen.EBAUTH GROUP BY time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_idp_pa_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_pa_users_year_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY idp_pa_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_pa_users_year_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY sp_pa_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_pa_users_year_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY total_pa_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_pa_users_year_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY time(12600w), year END;

CREATE CONTINUOUS QUERY sp_idp_ta_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_ta_users_year_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY idp_ta_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_ta_users_year_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY sp_ta_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_ta_users_year_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY total_ta_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_ta_users_year_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY time(12600w), year END;

CREATE CONTINUOUS QUERY sp_idp_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_users_year_unique FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY idp_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_users_year_unique FROM log_logins.autogen.EBAUTH GROUP BY idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY sp_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_users_year_unique FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY total_users_year_unique_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_users_year_unique FROM log_logins.autogen.EBAUTH GROUP BY time(12600w), year END;

CREATE CONTINUOUS QUERY sp_idp_pa_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_pa_users_week FROM log_logins.autogen.sp_idp_pa_users_day GROUP BY sp_entity_id, idp_entity_id, year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY idp_pa_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_pa_users_week FROM log_logins.autogen.idp_pa_users_day GROUP BY idp_entity_id, year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_pa_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_pa_users_week FROM log_logins.autogen.sp_pa_users_day GROUP BY sp_entity_id, year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY total_pa_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_pa_users_week FROM log_logins.autogen.total_pa_users_day GROUP BY year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_idp_ta_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_ta_users_week FROM log_logins.autogen.sp_idp_ta_users_day GROUP BY sp_entity_id, idp_entity_id, year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY idp_ta_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_ta_users_week FROM log_logins.autogen.idp_ta_users_day GROUP BY idp_entity_id, year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_ta_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_ta_users_week FROM log_logins.autogen.sp_ta_users_day GROUP BY sp_entity_id, year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY total_ta_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_ta_users_week FROM log_logins.autogen.total_ta_users_day GROUP BY year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_idp_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_users_week FROM log_logins.autogen.sp_idp_users_day GROUP BY sp_entity_id, idp_entity_id, year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY idp_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_users_week FROM log_logins.autogen.idp_users_day GROUP BY idp_entity_id, year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_users_week FROM log_logins.autogen.sp_users_day GROUP BY sp_entity_id, year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY total_users_week_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_users_week FROM log_logins.autogen.total_users_day GROUP BY year, month, quarter, time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_idp_pa_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_pa_users_month FROM log_logins.autogen.sp_idp_pa_users_week GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY idp_pa_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_pa_users_month FROM log_logins.autogen.idp_pa_users_week GROUP BY idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_pa_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_pa_users_month FROM log_logins.autogen.sp_pa_users_week GROUP BY sp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY total_pa_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_pa_users_month FROM log_logins.autogen.total_pa_users_week GROUP BY time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_idp_ta_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_ta_users_month FROM log_logins.autogen.sp_idp_ta_users_week GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY idp_ta_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_ta_users_month FROM log_logins.autogen.idp_ta_users_week GROUP BY idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_ta_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_ta_users_month FROM log_logins.autogen.sp_ta_users_week GROUP BY sp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY total_ta_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_ta_users_month FROM log_logins.autogen.total_ta_users_week GROUP BY time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_idp_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_users_month FROM log_logins.autogen.sp_idp_users_week GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY idp_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_users_month FROM log_logins.autogen.idp_users_week GROUP BY idp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_users_month FROM log_logins.autogen.sp_users_week GROUP BY sp_entity_id, time(12600w), year, month END;

CREATE CONTINUOUS QUERY total_users_month_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_users_month FROM log_logins.autogen.total_users_week GROUP BY time(12600w), year, month END;

CREATE CONTINUOUS QUERY sp_idp_pa_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_pa_users_quarter FROM log_logins.autogen.sp_idp_pa_users_week GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY idp_pa_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_pa_users_quarter FROM log_logins.autogen.idp_pa_users_week GROUP BY idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_pa_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_pa_users_quarter FROM log_logins.autogen.sp_pa_users_week GROUP BY sp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY total_pa_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_pa_users_quarter FROM log_logins.autogen.total_pa_users_week GROUP BY time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_idp_ta_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_ta_users_quarter FROM log_logins.autogen.sp_idp_ta_users_week GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY idp_ta_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_ta_users_quarter FROM log_logins.autogen.idp_ta_users_week GROUP BY idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_ta_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_ta_users_quarter FROM log_logins.autogen.sp_ta_users_week GROUP BY sp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY total_ta_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_ta_users_quarter FROM log_logins.autogen.total_ta_users_week GROUP BY time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_idp_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_users_quarter FROM log_logins.autogen.sp_idp_users_week GROUP BY sp_entity_id, idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY idp_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_users_quarter FROM log_logins.autogen.idp_users_week GROUP BY idp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_users_quarter FROM log_logins.autogen.sp_users_week GROUP BY sp_entity_id, time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY total_users_quarter_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_users_quarter FROM log_logins.autogen.total_users_week GROUP BY time(12600w), year, quarter END;

CREATE CONTINUOUS QUERY sp_idp_pa_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_pa_users_year FROM log_logins.autogen.sp_idp_pa_users_week GROUP BY sp_entity_id, idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY idp_pa_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_pa_users_year FROM log_logins.autogen.idp_pa_users_week GROUP BY idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY sp_pa_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_pa_users_year FROM log_logins.autogen.sp_pa_users_week GROUP BY sp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY total_pa_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_pa_users_year FROM log_logins.autogen.total_pa_users_week GROUP BY time(12600w), year END;

CREATE CONTINUOUS QUERY sp_idp_ta_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_ta_users_year FROM log_logins.autogen.sp_idp_ta_users_week GROUP BY sp_entity_id, idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY idp_ta_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_ta_users_year FROM log_logins.autogen.idp_ta_users_week GROUP BY idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY sp_ta_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_ta_users_year FROM log_logins.autogen.sp_ta_users_week GROUP BY sp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY total_ta_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_ta_users_year FROM log_logins.autogen.total_ta_users_week GROUP BY time(12600w), year END;

CREATE CONTINUOUS QUERY sp_idp_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_idp_users_year FROM log_logins.autogen.sp_idp_users_week GROUP BY sp_entity_id, idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY idp_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.idp_users_year FROM log_logins.autogen.idp_users_week GROUP BY idp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY sp_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.sp_users_year FROM log_logins.autogen.sp_users_week GROUP BY sp_entity_id, time(12600w), year END;

CREATE CONTINUOUS QUERY total_users_year_cq ON log_logins RESAMPLE EVERY 1d BEGIN SELECT sum(count_user_id) AS count_user_id INTO log_logins.autogen.total_users_year FROM log_logins.autogen.total_users_week GROUP BY time(12600w), year END;

CREATE CONTINUOUS QUERY sp_idp_pa_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_pa_users_week_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, idp_entity_id, time(1w, 4d) END;

CREATE CONTINUOUS QUERY idp_pa_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_pa_users_week_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY idp_entity_id, time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_pa_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_pa_users_week_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY sp_entity_id, time(1w, 4d) END;

CREATE CONTINUOUS QUERY total_pa_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_pa_users_week_unique FROM log_logins.autogen.EBAUTH WHERE state = 'prodaccepted' GROUP BY time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_idp_ta_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_ta_users_week_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, idp_entity_id, time(1w, 4d) END;

CREATE CONTINUOUS QUERY idp_ta_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_ta_users_week_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY idp_entity_id, time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_ta_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_ta_users_week_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY sp_entity_id, time(1w, 4d) END;

CREATE CONTINUOUS QUERY total_ta_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_ta_users_week_unique FROM log_logins.autogen.EBAUTH WHERE state = 'testaccepted' GROUP BY time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_idp_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_idp_users_week_unique FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, idp_entity_id, time(1w, 4d) END;

CREATE CONTINUOUS QUERY idp_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.idp_users_week_unique FROM log_logins.autogen.EBAUTH GROUP BY idp_entity_id, time(1w, 4d) END;

CREATE CONTINUOUS QUERY sp_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.sp_users_week_unique FROM log_logins.autogen.EBAUTH GROUP BY sp_entity_id, time(1w, 4d) END;

CREATE CONTINUOUS QUERY total_users_week_unique_cq ON log_logins RESAMPLE EVERY 6h FOR 2w BEGIN SELECT count(distinct(user_id)) AS distinct_count_user_id INTO log_logins.autogen.total_users_week_unique FROM log_logins.autogen.EBAUTH GROUP BY time(1w, 4d) END;

