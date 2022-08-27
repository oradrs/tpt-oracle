-- disable adaptive at session level

ALTER session SET optimizer_adaptive_features=FALSE;
ALTER session SET optimizer_adaptive_plans=FALSE;
ALTER session SET optimizer_adaptive_statistics=FALSE;

-- Verify
-- @optmzr_sess_param.sql
