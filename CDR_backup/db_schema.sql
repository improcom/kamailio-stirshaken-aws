CREATE TABLE `cdrs` (
                                `cdr_id` bigint NOT NULL AUTO_INCREMENT,
                                `src_username` varchar(64) NOT NULL DEFAULT '',
                                `src_domain` varchar(128) NOT NULL DEFAULT '',
                                `dst_username` varchar(64) NOT NULL DEFAULT '',
                                `dst_domain` varchar(128) NOT NULL DEFAULT '',
                                `dst_ousername` varchar(64) NOT NULL DEFAULT '',
                                `call_start_time` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
                                `duration` int unsigned NOT NULL DEFAULT '0',
                                `sip_call_id` varchar(128) NOT NULL DEFAULT '',
                                `sip_from_tag` varchar(128) NOT NULL DEFAULT '',
                                `sip_to_tag` varchar(128) NOT NULL DEFAULT '',
                                `src_ip` varchar(64) NOT NULL DEFAULT '',
                                `cost` int NOT NULL DEFAULT '0',
                                `rated` int NOT NULL DEFAULT '0',
                                `created` datetime NOT NULL,
                                PRIMARY KEY (`cdr_id`),
                                UNIQUE KEY `uk_cft` (`sip_call_id`,`sip_from_tag`,`sip_to_tag`)
        ) ENGINE=InnoDB AUTO_INCREMENT=2699 DEFAULT CHARSET=ascii