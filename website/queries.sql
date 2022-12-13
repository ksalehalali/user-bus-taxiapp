-- permission for owner for triq request 
INSERT INTO `permission_role` (`role_id`, `permission_id`) VALUES ('4', '65'), ('4', '66'), ('4', '67'), ('4', '68');

-- permission for owner for geofencing view
INSERT INTO `permission_role` (`role_id`, `permission_id`) VALUES ('4', '178'), ('4', '179'), ('4', '180');




ALTER TABLE `settings` CHANGE `value` `value` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL; 
INSERT INTO `settings` (`id`, `name`, `field`, `category`, `value`, `option_value`, `group_name`, `created_at`, `updated_at`) VALUES (NULL, 'enable-myfatoorah', 'select', 'payment_settings', '1', '{\"yes\":1,\"no\":0}', 'myfatoorah_setttings', NULL, NULL), (NULL, 'myfatoorah_mode', 'select', 'payment_settings', 'sandbox', '{\"sandbox\":\"sandbox\",\"production\":\"production\"}', 'myfatoorah_setttings', NULL, NULL), (NULL, 'my_fatoorah_api_key', 'text', 'payment_settings', 'Tfwjij9tbcHVD95LUQfsOtbfcEEkw1hkDGvUbWPs9CscSxZOttanv3olA6U6f84tBCXX93GpEqkaP_wfxEyNawiqZRb3Bmflyt5Iq5wUoMfWgyHwrAe1jcpvJP6xRq3FOeH5y9yXuiDaAILALa0hrgJH5Jom4wukj6msz20F96Dg7qBFoxO6tB62SRCnvBHe3R', '', 'myfatoorah_setttings', NULL, NULL);


