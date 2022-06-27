CREATE TABLE IF NOT EXISTS `missions` (
  `citizenid` varchar(250) CHARACTER SET latin1 COLLATE latin1_spanish_ci,
  `name` varchar(50) NOT NULL,
  `daily` int(3) NOT NULL DEFAULT 0,
  `hour` int(3) NOT NULL DEFAULT 0,
  `month` int(3) NOT NULL DEFAULT 1,
  `hidden` int(11) NOT NULL DEFAULT 0,
  `daily_mission` varchar(50) NOT NULL DEFAULT 'nomission',
  `hour_mission` varchar(50) NOT NULL DEFAULT 'nomission',
  `hidden_mission` varchar(50) NOT NULL DEFAULT 'nomission'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;