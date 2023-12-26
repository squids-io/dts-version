INSERT INTO casbin_rule (p_type, v0, v1, v2, v3, v4, v5, name) VALUES ('p','anonymous','api','/dts','GET','Y','','');
INSERT INTO casbin_rule (p_type, v0, v1, v2, v3, v4, v5, name) VALUES ('p','anonymous','api','/dts/grafana','POST','Y','','');
INSERT INTO casbin_rule (p_type, v0, v1, v2, v3, v4, v5, name) VALUES ('p','user','api','/api/motion','GET','Y','','');
INSERT INTO casbin_rule (p_type, v0, v1, v2, v3, v4, v5, name) VALUES ('p','user','api','/api/motion','POST','Y','','');
INSERT INTO casbin_rule (p_type, v0, v1, v2, v3, v4, v5, name) VALUES ('p','user','api','/api/motion','PUT','Y','','');
INSERT INTO casbin_rule (p_type, v0, v1, v2, v3, v4, v5, name) VALUES ('p','user','api','/api/motion','DELETE','Y','','');