
/*Create a default admin user*/

INSERT INTO survey_app.users (user_ID, username, password, enabled, name, email, role)
VALUES (1, 'admin', 'd033e22ae348aeb5660fc2140aec35850c4da997', TRUE, 'Administrator', 'example@gmail.com', "ROLE_ADMIN");
