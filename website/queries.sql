-- permission for owner for triq request 
INSERT INTO `permission_role` (`role_id`, `permission_id`) VALUES ('4', '65'), ('4', '66'), ('4', '67'), ('4', '68');

-- permission for owner for geofencing view
INSERT INTO `permission_role` (`role_id`, `permission_id`) VALUES ('4', '178'), ('4', '179'), ('4', '180');




ALTER TABLE `settings` CHANGE `value` `value` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL; 
INSERT INTO `settings` (`id`, `name`, `field`, `category`, `value`, `option_value`, `group_name`, `created_at`, `updated_at`) VALUES (NULL, 'enable-myfatoorah', 'select', 'payment_settings', '1', '{\"yes\":1,\"no\":0}', 'myfatoorah_setttings', NULL, NULL), (NULL, 'myfatoorah_mode', 'select', 'payment_settings', 'sandbox', '{\"sandbox\":\"sandbox\",\"production\":\"production\"}', 'myfatoorah_setttings', NULL, NULL), (NULL, 'my_fatoorah_api_key', 'text', 'payment_settings', 'Tfwjij9tbcHVD95LUQfsOtbfcEEkw1hkDGvUbWPs9CscSxZOttanv3olA6U6f84tBCXX93GpEqkaP_wfxEyNawiqZRb3Bmflyt5Iq5wUoMfWgyHwrAe1jcpvJP6xRq3FOeH5y9yXuiDaAILALa0hrgJH5Jom4wukj6msz20F96Dg7qBFoxO6tB62SRCnvBHe3R', '', 'myfatoorah_setttings', NULL, NULL);




TRUNCATE `requests`;
TRUNCATE `drivers`;
TRUNCATE `fleets`;
TRUNCATE `driver_wallet_history`;
TRUNCATE `oauth_access_tokens`;
TRUNCATE `driver_details`;
TRUNCATE `request_ratings`;
TRUNCATE `driver_documents`;
TRUNCATE `zone_types`;
TRUNCATE `chats`;
TRUNCATE `driver_rejected_requests`;
TRUNCATE `owners`;
TRUNCATE `request_bills`;
TRUNCATE `zones`;
TRUNCATE `zone_type_price`;
TRUNCATE `user_wallet`;
TRUNCATE `favourite_locations`;
TRUNCATE `driver_wallet`;
TRUNCATE `service_locations`;
TRUNCATE `request_places`;
TRUNCATE `distance_matrixes`;
TRUNCATE `cancellation_reasons`;
TRUNCATE `vehicle_types`;
TRUNCATE `driver_needed_documents`;
TRUNCATE `driver_availabilities`;
TRUNCATE `myfatoorah_transactions`;
TRUNCATE `user_wallet_history`;


ALTER TABLE `users` ADD `refferal_code_counter` INT(11) NOT NULL DEFAULT '0' AFTER `refferal_code`;



ALTER TABLE `zone_type_price` CHANGE `base_price` `base_price` DOUBLE(10,3) NOT NULL DEFAULT '0.000', CHANGE `price_per_distance` `price_per_distance` DOUBLE(10,3) NOT NULL DEFAULT '0.000', CHANGE `waiting_charge` `waiting_charge` DOUBLE(10,3) NOT NULL DEFAULT '0.000', CHANGE `price_per_time` `price_per_time` DOUBLE(10,3) NOT NULL DEFAULT '0.000', CHANGE `cancellation_fee` `cancellation_fee` DOUBLE(10,3) NOT NULL DEFAULT '0.000'; 




INSERT INTO `permissions` (`id`, `slug`, `name`, `description`, `main_menu`, `sub_menu`, `main_link`, `sub_link`, `sort`, `icon`, `created_at`, `updated_at`) VALUES (NULL, 'rating', 'rating', 'View Rating', 'rating', 'rating', NULL, NULL, NULL, 'fa fa-circle-thin', NULL, NULL);



INSERT INTO `permissions` (`id`, `slug`, `name`, `description`, `main_menu`, `sub_menu`, `main_link`, `sub_link`, `sort`, `icon`, `created_at`, `updated_at`) VALUES (NULL, 'add-rating-title', 'add-rating-title', 'View Rating Title', 'rating', 'rating-title', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `permissions` (`id`, `slug`, `name`, `description`, `main_menu`, `sub_menu`, `main_link`, `sub_link`, `sort`, `icon`, `created_at`, `updated_at`) VALUES (NULL, 'edit-rating-title', 'edit-rating-title', 'View Rating Title', 'rating', 'rating-title', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `permissions` (`id`, `slug`, `name`, `description`, `main_menu`, `sub_menu`, `main_link`, `sub_link`, `sort`, `icon`, `created_at`, `updated_at`) VALUES (NULL, 'delete-rating-title', 'delete-rating-title', 'View Rating Title', 'rating', 'rating-title', NULL, NULL, NULL, NULL, NULL, NULL);



CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `star` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `rating`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `rating`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

  
ALTER TABLE `ratings` ADD `user_type` VARCHAR(50) NOT NULL AFTER `star`;
CREATE TABLE `taxi`.`feedback` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `user_id` INT(11) NOT NULL ,
  `rating_id` INT(11) NOT NULL ,
  `request_id` INT(11) NOT NULL ,
  `created_at` DATETIME NOT NULL ,
  `updated_at` DATETIME NOT NULL ,
  PRIMARY KEY (`id`)) ENGINE = InnoDB;

ALTER TABLE `feedback` CHANGE `request_id` `request_id` CHAR(36) NOT NULL; 



ALTER TABLE `feedback` ADD `user_type` VARCHAR(255) NOT NULL AFTER `user_id`;
ALTER TABLE `feedback` ADD `star` TINYINT(1) NOT NULL AFTER `user_type`;

