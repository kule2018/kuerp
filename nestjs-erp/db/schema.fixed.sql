
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `kuerp_area` (
  `id` int(10) NOT NULL COMMENT 'ID',
  `pid` int(10) NULL DEFAULT NULL COMMENT '父id',
  `shortname` varchar(100) CHARACTER SET utf8mb4 NULL DEFAULT NULL COMMENT '简称',
  `name` varchar(100) CHARACTER SET utf8mb4 NULL DEFAULT NULL COMMENT '名称',
  `level` tinyint(4) NULL DEFAULT NULL COMMENT '层级 0 1 2 省市区县',
  `adcode` varchar(100) CHARACTER SET utf8mb4 NULL DEFAULT NULL COMMENT '地区编号',
  `lng` varchar(100) CHARACTER SET utf8mb4 NULL DEFAULT NULL COMMENT '经度',
  `lat` varchar(100) CHARACTER SET utf8mb4 NULL DEFAULT NULL COMMENT '纬度'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='地区表';

INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1, 0, '河南省', '河南省', 1, '410000', '113.753094', '34.767052');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2, 1, '洛阳市', '洛阳市', 2, '410300', '112.453895', '34.619702');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3, 2, '栾川县', '栾川县', 3, '410324', '111.615729', '33.7857');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (4, 2, '新安县', '新安县', 3, '410323', '112.13246', '34.728909');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (5, 2, '洛宁县', '洛宁县', 3, '410328', '111.652958', '34.389371');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (6, 2, '偃师区', '偃师区', 3, '410381', '112.789375', '34.72715');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (7, 2, '瀍河回族区', '瀍河回族区', 3, '410304', '112.500131', '34.679773');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (8, 2, '老城区', '老城区', 3, '410302', '112.44671', '34.698617');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (9, 2, '洛龙区', '洛龙区', 3, '410311', '112.463833', '34.619711');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (10, 2, '宜阳县', '宜阳县', 3, '410327', '112.179187', '34.51462');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (11, 2, '嵩县', '嵩县', 3, '410325', '112.085432', '34.134639');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (12, 2, '西工区', '西工区', 3, '410303', '112.428183', '34.659959');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (13, 2, '涧西区', '涧西区', 3, '410305', '112.395766', '34.658177');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (14, 2, '伊川县', '伊川县', 3, '410329', '112.425751', '34.421741');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (15, 2, '汝阳县', '汝阳县', 3, '410326', '112.473013', '34.154283');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (16, 2, '孟津区', '孟津区', 3, '410306', '112.44525', '34.825587');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (17, 1, '三门峡市', '三门峡市', 2, '411200', '111.200482', '34.773196');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (18, 17, '湖滨区', '湖滨区', 3, '411202', '111.188552', '34.771296');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (19, 17, '渑池县', '渑池县', 3, '411221', '111.761753', '34.767937');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (20, 17, '卢氏县', '卢氏县', 3, '411224', '111.04522', '34.051866');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (21, 17, '义马市', '义马市', 3, '411281', '111.874726', '34.747563');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (22, 17, '陕州区', '陕州区', 3, '411203', '111.103252', '34.72066');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (23, 17, '灵宝市', '灵宝市', 3, '411282', '110.894225', '34.517734');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (24, 1, '漯河市', '漯河市', 2, '411100', '114.0166', '33.58038');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (25, 24, '临颍县', '临颍县', 3, '411122', '113.931121', '33.828096');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (26, 24, '召陵区', '召陵区', 3, '411104', '114.093879', '33.586509');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (27, 24, '源汇区', '源汇区', 3, '411102', '113.984164', '33.572319');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (28, 24, '舞阳县', '舞阳县', 3, '411121', '113.609327', '33.438259');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (29, 24, '郾城区', '郾城区', 3, '411103', '114.006596', '33.587697');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (30, 1, '许昌市', '许昌市', 2, '411000', '113.852004', '34.03732');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (31, 30, '建安区', '建安区', 3, '411003', '113.822869', '34.124729');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (32, 30, '魏都区', '魏都区', 3, '411002', '113.830826', '34.047189');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (33, 30, '鄢陵县', '鄢陵县', 3, '411024', '114.177329', '34.102985');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (34, 30, '襄城县', '襄城县', 3, '411025', '113.506904', '33.851609');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (35, 30, '禹州市', '禹州市', 3, '411081', '113.488715', '34.142442');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (36, 30, '长葛市', '长葛市', 3, '411082', '113.813972', '34.195458');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (37, 1, '南阳市', '南阳市', 2, '411300', '112.528549', '32.990218');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (38, 37, '西峡县', '西峡县', 3, '411323', '111.473644', '33.307272');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (39, 37, '卧龙区', '卧龙区', 3, '411303', '112.5287888', '32.98987657');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (40, 37, '唐河县', '唐河县', 3, '411328', '112.80829', '32.682464');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (41, 37, '南召县', '南召县', 3, '411321', '112.429277', '33.489804');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (42, 37, '镇平县', '镇平县', 3, '411324', '112.234571', '33.033826');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (43, 37, '淅川县', '淅川县', 3, '411326', '111.490902', '33.137831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (44, 37, '内乡县', '内乡县', 3, '411325', '111.849354', '33.044698');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (45, 37, '宛城区', '宛城区', 3, '411302', '112.539506', '33.003564');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (46, 37, '桐柏县', '桐柏县', 3, '411330', '113.428702', '32.379164');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (47, 37, '邓州市', '邓州市', 3, '411381', '112.08745', '32.687732');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (48, 37, '方城县', '方城县', 3, '411322', '113.012849', '33.255387');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (49, 37, '社旗县', '社旗县', 3, '411327', '112.948183', '33.056229');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (50, 37, '新野县', '新野县', 3, '411329', '112.3601', '32.521282');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (51, 1, '济源市', '济源市', 2, '419001', '112.602347', '35.069057');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (52, 51, '济源市坡头镇', '济源市坡头镇', 3, '419001', '112.538', '34.9308');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (53, 51, '济源市梨林镇', '济源市梨林镇', 3, '419001', '112.753', '35.0882');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (54, 51, '济源市大峪镇', '济源市大峪镇', 3, '419001', '112.338', '34.9398');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (55, 51, '济源市思礼镇', '济源市思礼镇', 3, '419001', '112.388', '35.2103');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (56, 51, '济源市五龙口镇', '济源市五龙口镇', 3, '419001', '112.761', '35.1956');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (57, 51, '济源市王屋镇', '济源市王屋镇', 3, '419001', '112.169', '35.1244');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (58, 51, '济源市玉泉街道', '济源市玉泉街道', 3, '419001', '112.624', '35.1189');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (59, 51, '济源市轵城镇', '济源市轵城镇', 3, '419001', '112.622', '35.0625');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (60, 51, '济源市济水街道', '济源市济水街道', 3, '419001', '112.595', '35.0944');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (61, 51, '济源市沁园街道', '济源市沁园街道', 3, '419001', '112.593', '35.0822');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (62, 51, '济源市下冶镇', '济源市下冶镇', 3, '419001', '112.212', '35.1131');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (63, 51, '济源市克井镇', '济源市克井镇', 3, '419001', '112.635', '35.255');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (64, 51, '济源市天坛街道', '济源市天坛街道', 3, '419001', '112.567', '35.1229');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (65, 51, '济源市邵原镇', '济源市邵原镇', 3, '419001', '112.114', '35.2705');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (66, 51, '济源市北海街道', '济源市北海街道', 3, '419001', '112.569', '35.1116');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (67, 51, '济源市承留镇', '济源市承留镇', 3, '419001', '112.509', '35.0243');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (68, 1, '信阳市', '信阳市', 2, '411500', '114.091058', '32.148624');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (69, 68, '罗山县', '罗山县', 3, '411521', '114.512838', '32.20436');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (70, 68, '淮滨县', '淮滨县', 3, '411527', '115.420101', '32.474772');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (71, 68, '浉河区', '浉河区', 3, '411502', '114.05867', '32.116885');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (72, 68, '商城县', '商城县', 3, '411524', '115.406894', '31.79832');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (73, 68, '固始县', '固始县', 3, '411525', '115.654066', '32.169239');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (74, 68, '平桥区', '平桥区', 3, '411503', '114.125595', '32.101005');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (75, 68, '潢川县', '潢川县', 3, '411526', '115.051683', '32.131426');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (76, 68, '新县', '新县', 3, '411523', '114.879309', '31.643914');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (77, 68, '息县', '息县', 3, '411528', '114.740392', '32.34312');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (78, 68, '光山县', '光山县', 3, '411522', '114.91934', '32.010736');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (79, 1, '濮阳市', '濮阳市', 2, '410900', '115.029246', '35.762731');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (80, 79, '台前县', '台前县', 3, '410927', '115.871671', '35.970286');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (81, 79, '南乐县', '南乐县', 3, '410923', '115.205876', '36.070219');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (82, 79, '范县', '范县', 3, '410926', '115.504081', '35.85302');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (83, 79, '清丰县', '清丰县', 3, '410922', '115.104602', '35.886694');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (84, 79, '华龙区', '华龙区', 3, '410902', '115.074453', '35.778289');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (85, 79, '濮阳县', '濮阳县', 3, '410928', '115.029165', '35.713113');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (86, 1, '驻马店市', '驻马店市', 2, '411700', '114.021988', '33.014038');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (87, 86, '上蔡县', '上蔡县', 3, '411722', '114.264381', '33.262439');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (88, 86, '西平县', '西平县', 3, '411721', '114.021492', '33.387658');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (89, 86, '新蔡县', '新蔡县', 3, '411729', '114.965519', '32.74488');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (90, 86, '泌阳县', '泌阳县', 3, '411726', '113.327144', '32.723974');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (91, 86, '遂平县', '遂平县', 3, '411728', '114.013323', '33.146316');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (92, 86, '平舆县', '平舆县', 3, '411723', '114.618537', '32.96344');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (93, 86, '驿城区', '驿城区', 3, '411702', '113.993753', '32.97455');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (94, 86, '确山县', '确山县', 3, '411725', '114.016818', '32.82134');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (95, 86, '正阳县', '正阳县', 3, '411724', '114.392774', '32.605697');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (96, 86, '汝南县', '汝南县', 3, '411727', '114.362477', '33.006808');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (97, 1, '郑州市', '郑州市', 2, '410100', '113.625351', '34.746303');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (98, 97, '登封市', '登封市', 3, '410185', '113.05056', '34.454877');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (99, 97, '新密市', '新密市', 3, '410183', '113.390932', '34.540216');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (100, 97, '新郑市', '新郑市', 3, '410184', '113.74024', '34.396479');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (101, 97, '上街区', '上街区', 3, '410106', '113.309185', '34.803514');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (102, 97, '中牟县', '中牟县', 3, '410122', '113.975798', '34.720535');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (103, 97, '巩义市', '巩义市', 3, '410181', '113.022354', '34.748207');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (104, 97, '惠济区', '惠济区', 3, '410108', '113.617055', '34.867994');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (105, 97, '中原区', '中原区', 3, '410102', '113.612966', '34.74828');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (106, 97, '荥阳市', '荥阳市', 3, '410182', '113.383385', '34.7866');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (107, 97, '二七区', '二七区', 3, '410103', '113.640177', '34.724138');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (108, 97, '金水区', '金水区', 3, '410105', '113.6603', '34.800415');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (109, 97, '管城回族区', '管城回族区', 3, '410104', '113.677446', '34.754436');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (110, 1, '鹤壁市', '鹤壁市', 2, '410600', '114.297305', '35.748329');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (111, 110, '淇县', '淇县', 3, '410622', '114.208851', '35.622571');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (112, 110, '浚县', '浚县', 3, '410621', '114.550611', '35.677249');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (113, 110, '鹤山区', '鹤山区', 3, '410602', '114.163133', '35.954647');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (114, 110, '山城区', '山城区', 3, '410603', '114.184391', '35.897862');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (115, 110, '淇滨区', '淇滨区', 3, '410611', '114.298748', '35.741763');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (116, 1, '焦作市', '焦作市', 2, '410800', '113.241902', '35.215726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (117, 116, '马村区', '马村区', 3, '410804', '113.32212', '35.257084');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (118, 116, '沁阳市', '沁阳市', 3, '410882', '112.950873', '35.087569');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (119, 116, '孟州市', '孟州市', 3, '410883', '112.791372', '34.907229');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (120, 116, '博爱县', '博爱县', 3, '410822', '113.064701', '35.170332');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (121, 116, '修武县', '修武县', 3, '410821', '113.447862', '35.22286');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (122, 116, '中站区', '中站区', 3, '410803', '113.182847', '35.237227');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (123, 116, '解放区', '解放区', 3, '410802', '113.230555', '35.240403');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (124, 116, '山阳区', '山阳区', 3, '410811', '113.254581', '35.215054');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (125, 116, '武陟县', '武陟县', 3, '410823', '113.401848', '35.099458');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (126, 116, '温县', '温县', 3, '410825', '113.08067', '34.93961');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (127, 1, '安阳市', '安阳市', 2, '410500', '114.39248', '36.098779');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (128, 127, '殷都区', '殷都区', 3, '410505', '114.303454', '36.109938');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (129, 127, '内黄县', '内黄县', 3, '410527', '114.90146', '35.972016');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (130, 127, '安阳县', '安阳县', 3, '410522', '114.462953', '36.09211');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (131, 127, '龙安区', '龙安区', 3, '410506', '114.301037', '36.076937');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (132, 127, '北关区', '北关区', 3, '410503', '114.355742', '36.10766');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (133, 127, '林州市', '林州市', 3, '410581', '113.819275', '36.084127');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (134, 127, '汤阴县', '汤阴县', 3, '410523', '114.357686', '35.925155');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (135, 127, '滑县', '滑县', 3, '410526', '114.517977', '35.576128');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (136, 127, '文峰区', '文峰区', 3, '410502', '114.356967', '36.090593');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (137, 1, '新乡市', '新乡市', 2, '410700', '113.92679', '35.303589');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (138, 137, '凤泉区', '凤泉区', 3, '410704', '113.916183', '35.384428');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (139, 137, '长垣市', '长垣市', 3, '410783', '114.66885', '35.201628');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (140, 137, '牧野区', '牧野区', 3, '410711', '113.908561', '35.315614');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (141, 137, '卫滨区', '卫滨区', 3, '410703', '113.865666', '35.301796');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (142, 137, '新乡县', '新乡县', 3, '410721', '113.813884', '35.170066');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (143, 137, '获嘉县', '获嘉县', 3, '410724', '113.657551', '35.260153');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (144, 137, '封丘县', '封丘县', 3, '410727', '114.418907', '35.041237');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (145, 137, '原阳县', '原阳县', 3, '410725', '113.939829', '35.066873');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (146, 137, '红旗区', '红旗区', 3, '410702', '113.875211', '35.302952');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (147, 137, '卫辉市', '卫辉市', 3, '410781', '114.064584', '35.398357');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (148, 137, '辉县市', '辉县市', 3, '410782', '113.80572', '35.462964');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (149, 137, '延津县', '延津县', 3, '410726', '114.205624', '35.165876');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (150, 1, '平顶山市', '平顶山市', 2, '410400', '113.192595', '33.766554');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (151, 150, '湛河区', '湛河区', 3, '410411', '113.3208727', '33.72568115');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (152, 150, '鲁山县', '鲁山县', 3, '410423', '112.908052', '33.738434');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (153, 150, '卫东区', '卫东区', 3, '410403', '113.335316', '33.735388');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (154, 150, '舞钢市', '舞钢市', 3, '410481', '113.516427', '33.314147');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (155, 150, '叶县', '叶县', 3, '410422', '113.357476', '33.627437');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (156, 150, '新华区', '新华区', 3, '410402', '113.293977', '33.737251');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (157, 150, '石龙区', '石龙区', 3, '410404', '112.898845', '33.899247');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (158, 150, '郏县', '郏县', 3, '410425', '113.21261', '33.971787');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (159, 150, '汝州市', '汝州市', 3, '410482', '112.844696', '34.16717');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (160, 150, '宝丰县', '宝丰县', 3, '410421', '113.054538', '33.869159');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (161, 1, '周口市', '周口市', 2, '411600', '114.701222', '33.634652');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (162, 161, '项城市', '项城市', 3, '411681', '114.875128', '33.465609');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (163, 161, '商水县', '商水县', 3, '411623', '114.608135', '33.562072');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (164, 161, '川汇区', '川汇区', 3, '411602', '114.650551', '33.647679');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (165, 161, '鹿邑县', '鹿邑县', 3, '411628', '115.484525', '33.860698');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (166, 161, '郸城县', '郸城县', 3, '411625', '115.177141', '33.64601');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (167, 161, '淮阳区', '淮阳区', 3, '411603', '114.852604', '33.731543');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (168, 161, '西华县', '西华县', 3, '411622', '114.529709', '33.768277');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (169, 161, '扶沟县', '扶沟县', 3, '411621', '114.394666', '34.060062');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (170, 161, '沈丘县', '沈丘县', 3, '411624', '115.098541', '33.409805');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (171, 161, '太康县', '太康县', 3, '411627', '114.837946', '34.064513');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (172, 1, '开封市', '开封市', 2, '410200', '114.314278', '34.798083');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (173, 172, '杞县', '杞县', 3, '410221', '114.782629', '34.549731');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (174, 172, '祥符区', '祥符区', 3, '410212', '114.441406', '34.757546');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (175, 172, '尉氏县', '尉氏县', 3, '410223', '114.19305', '34.411437');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (176, 172, '禹王台区', '禹王台区', 3, '410205', '114.348105', '34.777052');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (177, 172, '通许县', '通许县', 3, '410222', '114.47315', '34.502053');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (178, 172, '兰考县', '兰考县', 3, '410225', '114.818228', '34.856372');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (179, 172, '顺河回族区', '顺河回族区', 3, '410203', '114.360824', '34.795933');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (180, 172, '鼓楼区', '鼓楼区', 3, '410204', '114.348356', '34.788473');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (181, 172, '龙亭区', '龙亭区', 3, '410202', '114.355378', '34.815515');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (182, 1, '商丘市', '商丘市', 2, '411400', '115.656358', '34.415165');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (183, 182, '宁陵县', '宁陵县', 3, '411423', '115.314221', '34.461226');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (184, 182, '睢阳区', '睢阳区', 3, '411403', '115.653258', '34.389048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (185, 182, '夏邑县', '夏邑县', 3, '411426', '116.131422', '34.237801');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (186, 182, '永城市', '永城市', 3, '411481', '116.449864', '33.929927');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (187, 182, '睢县', '睢县', 3, '411422', '115.071957', '34.446572');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (188, 182, '民权县', '民权县', 3, '411421', '115.175019', '34.648384');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (189, 182, '梁园区', '梁园区', 3, '411402', '115.613609', '34.444519');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (190, 182, '柘城县', '柘城县', 3, '411424', '115.305182', '34.092015');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (191, 182, '虞城县', '虞城县', 3, '411425', '115.828519', '34.400868');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (192, 0, '广东省', '广东省', 1, '440000', '113.266887', '23.133306');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (193, 192, '汕头市', '汕头市', 2, '440500', '116.681956', '23.354152');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (194, 193, '澄海区', '澄海区', 3, '440515', '116.755945', '23.466314');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (195, 193, '濠江区', '濠江区', 3, '440512', '116.726701', '23.286605');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (196, 193, '南澳县', '南澳县', 3, '440523', '117.023482', '23.421658');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (197, 193, '龙湖区', '龙湖区', 3, '440507', '116.716464', '23.372211');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (198, 193, '金平区', '金平区', 3, '440511', '116.70341', '23.365716');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (199, 193, '潮南区', '潮南区', 3, '440514', '116.439105', '23.239196');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (200, 193, '潮阳区', '潮阳区', 3, '440513', '116.601677', '23.264923');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (201, 192, '佛山市', '佛山市', 2, '440600', '113.121586', '23.021351');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (202, 201, '三水区', '三水区', 3, '440607', '112.897271', '23.156675');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (203, 201, '高明区', '高明区', 3, '440608', '112.892573', '22.900047');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (204, 201, '顺德区', '顺德区', 3, '440606', '113.293197', '22.805413');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (205, 201, '禅城区', '禅城区', 3, '440604', '113.122532', '23.009475');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (206, 201, '南海区', '南海区', 3, '440605', '113.143246', '23.028875');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (207, 192, '肇庆市', '肇庆市', 2, '441200', '112.465245', '23.047747');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (208, 207, '广宁县', '广宁县', 3, '441223', '112.440694', '23.634808');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (209, 207, '怀集县', '怀集县', 3, '441224', '112.166908', '23.920806');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (210, 207, '封开县', '封开县', 3, '441225', '111.512177', '23.423928');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (211, 207, '四会市', '四会市', 3, '441284', '112.734309', '23.326991');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (212, 207, '德庆县', '德庆县', 3, '441226', '111.785544', '23.145035');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (213, 207, '端州区', '端州区', 3, '441202', '112.485577', '23.051847');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (214, 207, '鼎湖区', '鼎湖区', 3, '441203', '112.56738', '23.159062');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (215, 207, '高要区', '高要区', 3, '441204', '112.458055', '23.02474');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (216, 192, '惠州市', '惠州市', 2, '441300', '114.415587', '23.112368');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (217, 216, '博罗县', '博罗县', 3, '441322', '114.289602', '23.172587');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (218, 216, '龙门县', '龙门县', 3, '441324', '114.254898', '23.727873');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (219, 216, '惠东县', '惠东县', 3, '441323', '114.720136', '22.984831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (220, 216, '惠阳区', '惠阳区', 3, '441303', '114.456107', '22.789431');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (221, 216, '惠城区', '惠城区', 3, '441302', '114.382526', '23.084657');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (222, 192, '深圳市', '深圳市', 2, '440300', '114.057939', '22.543527');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (223, 222, '宝安区', '宝安区', 3, '440306', '113.883831', '22.554986');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (224, 222, '南山区', '南山区', 3, '440305', '113.930478', '22.533191');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (225, 222, '福田区', '福田区', 3, '440304', '114.055198', '22.520922');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (226, 222, '罗湖区', '罗湖区', 3, '440303', '114.131611', '22.548309');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (227, 222, '龙岗区', '龙岗区', 3, '440307', '114.246884', '22.720889');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (228, 222, '光明区', '光明区', 3, '440311', '113.936059', '22.74875');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (229, 222, '龙华区', '龙华区', 3, '440309', '114.04491', '22.696735');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (230, 222, '坪山区', '坪山区', 3, '440310', '114.350844', '22.708786');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (231, 222, '盐田区', '盐田区', 3, '440308', '114.236739', '22.557001');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (232, 192, '珠海市', '珠海市', 2, '440400', '113.576892', '22.271644');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (233, 232, '香洲区', '香洲区', 3, '440402', '113.543372', '22.265635');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (234, 232, '斗门区', '斗门区', 3, '440403', '113.296228', '22.209134');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (235, 232, '金湾区', '金湾区', 3, '440404', '113.363224', '22.146717');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (236, 192, '湛江市', '湛江市', 2, '440800', '110.357538', '21.270108');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (237, 236, '廉江市', '廉江市', 3, '440881', '110.286109', '21.609988');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (238, 236, '雷州市', '雷州市', 3, '440882', '110.097011', '20.914548');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (239, 236, '吴川市', '吴川市', 3, '440883', '110.779361', '21.440763');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (240, 236, '麻章区', '麻章区', 3, '440811', '110.333833', '21.26437');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (241, 236, '徐闻县', '徐闻县', 3, '440825', '110.17595', '20.325969');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (242, 236, '霞山区', '霞山区', 3, '440803', '110.397721', '21.192463');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (243, 236, '坡头区', '坡头区', 3, '440804', '110.455192', '21.244405');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (244, 236, '遂溪县', '遂溪县', 3, '440823', '110.25043', '21.378371');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (245, 236, '赤坎区', '赤坎区', 3, '440802', '110.365592', '21.265948');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (246, 192, '江门市', '江门市', 2, '440700', '113.081548', '22.578948');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (247, 246, '鹤山市', '鹤山市', 3, '440784', '112.964203', '22.765912');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (248, 246, '台山市', '台山市', 3, '440781', '112.793812', '22.251947');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (249, 246, '江海区', '江海区', 3, '440704', '113.111029', '22.561301');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (250, 246, '开平市', '开平市', 3, '440783', '112.698113', '22.377378');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (251, 246, '恩平市', '恩平市', 3, '440785', '112.304904', '22.183743');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (252, 246, '新会区', '新会区', 3, '440705', '113.034454', '22.458519');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (253, 246, '蓬江区', '蓬江区', 3, '440703', '113.078914', '22.595285');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (254, 192, '茂名市', '茂名市', 2, '440900', '110.925533', '21.662728');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (255, 254, '化州市', '化州市', 3, '440982', '110.639581', '21.664483');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (256, 254, '电白区', '电白区', 3, '440904', '111.013368', '21.513946');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (257, 254, '高州市', '高州市', 3, '440981', '110.853169', '21.918017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (258, 254, '信宜市', '信宜市', 3, '440983', '110.946866', '22.354887');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (259, 254, '茂南区', '茂南区', 3, '440902', '110.918566', '21.641661');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (260, 192, '揭阳市', '揭阳市', 2, '445200', '116.372732', '23.550968');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (261, 260, '普宁市', '普宁市', 3, '445281', '116.165646', '23.297742');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (262, 260, '惠来县', '惠来县', 3, '445224', '116.295038', '23.033889');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (263, 260, '榕城区', '榕城区', 3, '445202', '116.36714', '23.525918');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (264, 260, '揭东区', '揭东区', 3, '445203', '116.411928', '23.567252');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (265, 260, '揭西县', '揭西县', 3, '445222', '115.841742', '23.431314');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (266, 192, '汕尾市', '汕尾市', 2, '441500', '115.375557', '22.787204');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (267, 266, '陆河县', '陆河县', 3, '441523', '115.659978', '23.301557');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (268, 266, '海丰县', '海丰县', 3, '441521', '115.322974', '22.967212');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (269, 266, '陆丰市', '陆丰市', 3, '441581', '115.652142', '22.91874');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (270, 266, '城区', '城区', 3, '441502', '115.36522', '22.779204');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (271, 192, '阳江市', '阳江市', 2, '441700', '111.98343', '21.856853');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (272, 271, '阳春市', '阳春市', 3, '441781', '111.791587', '22.17041');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (273, 271, '江城区', '江城区', 3, '441702', '111.95486', '21.862451');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (274, 271, '阳西县', '阳西县', 3, '441721', '111.617696', '21.753935');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (275, 271, '阳东区', '阳东区', 3, '441704', '112.005586', '21.869081');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (276, 192, '梅州市', '梅州市', 2, '441400', '116.122046', '24.288832');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (277, 276, '平远县', '平远县', 3, '441426', '115.891235', '24.566928');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (278, 276, '蕉岭县', '蕉岭县', 3, '441427', '116.171477', '24.658963');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (279, 276, '兴宁市', '兴宁市', 3, '441481', '115.731133', '24.137296');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (280, 276, '丰顺县', '丰顺县', 3, '441423', '116.181895', '23.739364');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (281, 276, '梅县区', '梅县区', 3, '441403', '116.081395', '24.266191');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (282, 276, '大埔县', '大埔县', 3, '441422', '116.694825', '24.347037');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (283, 276, '梅江区', '梅江区', 3, '441402', '116.116686', '24.31065');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (284, 276, '五华县', '五华县', 3, '441424', '115.775751', '23.932568');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (285, 192, '潮州市', '潮州市', 2, '445100', '116.621901', '23.657662');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (286, 285, '饶平县', '饶平县', 3, '445122', '117.0045', '23.663294');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (287, 285, '湘桥区', '湘桥区', 3, '445102', '116.628343', '23.675104');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (288, 285, '潮安区', '潮安区', 3, '445103', '116.676971', '23.463598');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (289, 192, '云浮市', '云浮市', 2, '445300', '112.044524', '22.915163');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (290, 289, '郁南县', '郁南县', 3, '445322', '111.535387', '23.234561');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (291, 289, '罗定市', '罗定市', 3, '445381', '111.569788', '22.768345');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (292, 289, '新兴县', '新兴县', 3, '445321', '112.225174', '22.695915');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (293, 289, '云城区', '云城区', 3, '445302', '112.043945', '22.92815');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (294, 289, '云安区', '云安区', 3, '445303', '112.002947', '23.070334');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (295, 192, '河源市', '河源市', 2, '441600', '114.700215', '23.744276');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (296, 295, '和平县', '和平县', 3, '441624', '114.935634', '24.469177');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (297, 295, '连平县', '连平县', 3, '441623', '114.488358', '24.369552');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (298, 295, '龙川县', '龙川县', 3, '441622', '115.26002', '24.100599');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (299, 295, '东源县', '东源县', 3, '441625', '114.7466', '23.790079');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (300, 295, '紫金县', '紫金县', 3, '441621', '115.183814', '23.635597');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (301, 295, '源城区', '源城区', 3, '441602', '114.703305', '23.734055');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (302, 192, '韶关市', '韶关市', 2, '440200', '113.597324', '24.810977');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (303, 302, '仁化县', '仁化县', 3, '440224', '113.749175', '25.085764');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (304, 302, '南雄市', '南雄市', 3, '440282', '114.31184', '25.117653');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (305, 302, '浈江区', '浈江区', 3, '440204', '113.611077', '24.804898');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (306, 302, '始兴县', '始兴县', 3, '440222', '114.061998', '24.953908');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (307, 302, '乳源瑶族自治县', '乳源瑶族自治县', 3, '440232', '113.275875', '24.775856');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (308, 302, '武江区', '武江区', 3, '440203', '113.58792', '24.7929');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (309, 302, '曲江区', '曲江区', 3, '440205', '113.604591', '24.682826');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (310, 302, '翁源县', '翁源县', 3, '440229', '114.129986', '24.350581');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (311, 302, '新丰县', '新丰县', 3, '440233', '114.206641', '24.059909');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (312, 302, '乐昌市', '乐昌市', 3, '440281', '113.347669', '25.129892');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (313, 192, '清远市', '清远市', 2, '441800', '113.056098', '23.682064');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (314, 313, '连南瑶族自治县', '连南瑶族自治县', 3, '441826', '112.287212', '24.725953');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (315, 313, '连州市', '连州市', 3, '441882', '112.377255', '24.780873');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (316, 313, '连山壮族瑶族自治县', '连山壮族瑶族自治县', 3, '441825', '112.093726', '24.570553');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (317, 313, '英德市', '英德市', 3, '441881', '113.401827', '24.20716');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (318, 313, '佛冈县', '佛冈县', 3, '441821', '113.531559', '23.879455');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (319, 313, '阳山县', '阳山县', 3, '441823', '112.641199', '24.465234');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (320, 313, '清城区', '清城区', 3, '441802', '113.062612', '23.697889');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (321, 313, '清新区', '清新区', 3, '441803', '113.017747', '23.734677');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (322, 192, '中山市', '中山市', 2, '442000', '113.392517', '22.517024');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (323, 322, '三角镇', '三角镇', 3, '442000', '113.416', '22.7079');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (324, 322, '横栏镇', '横栏镇', 3, '442000', '113.224', '22.6048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (325, 322, '五桂山街道', '五桂山街道', 3, '442000', '113.399', '22.4847');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (326, 322, '小榄镇', '小榄镇', 3, '442000', '113.321', '22.5607');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (327, 322, '神湾镇', '神湾镇', 3, '442000', '113.376', '22.2768');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (328, 322, '中山港街道', '中山港街道', 3, '442000', '113.42', '22.5577');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (329, 322, '古镇镇', '古镇镇', 3, '442000', '113.167', '22.6751');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (330, 322, '南朗街道', '南朗街道', 3, '442000', '113.482', '22.519');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (331, 322, '民众街道', '民众街道', 3, '442000', '113.499', '22.6855');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (332, 322, '港口镇', '港口镇', 3, '442000', '113.354', '22.6027');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (333, 322, '三乡镇', '三乡镇', 3, '442000', '113.432', '22.3879');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (334, 322, '石岐街道', '石岐街道', 3, '442000', '113.405', '22.5247');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (335, 322, '大涌镇', '大涌镇', 3, '442000', '113.297', '22.4834');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (336, 322, '南头镇', '南头镇', 3, '442000', '113.328', '22.6882');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (337, 322, '黄圃镇', '黄圃镇', 3, '442000', '113.329', '22.7457');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (338, 322, '东区街道', '东区街道', 3, '442000', '113.4', '22.5274');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (339, 322, '阜沙镇', '阜沙镇', 3, '442000', '113.34', '22.6406');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (340, 322, '板芙镇', '板芙镇', 3, '442000', '113.358', '22.4068');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (341, 322, '坦洲镇', '坦洲镇', 3, '442000', '113.38', '22.2868');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (342, 322, '西区街道', '西区街道', 3, '442000', '113.314', '22.5649');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (343, 322, '沙溪镇', '沙溪镇', 3, '442000', '113.344', '22.5248');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (344, 322, '南区街道', '南区街道', 3, '442000', '113.367', '22.4892');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (345, 322, '东凤镇', '东凤镇', 3, '442000', '113.308', '22.6803');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (346, 192, '东莞市', '东莞市', 2, '441900', '113.751884', '23.021016');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (347, 346, '莞城街道', '莞城街道', 3, '441900', '113.743', '23.0225');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (348, 346, '常平镇', '常平镇', 3, '441900', '114.036', '23.0074');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (349, 346, '大朗镇', '大朗镇', 3, '441900', '113.939', '22.8654');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (350, 346, '麻涌镇', '麻涌镇', 3, '441900', '113.562', '22.9718');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (351, 346, '望牛墩镇', '望牛墩镇', 3, '441900', '113.676', '23.0683');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (352, 346, '凤岗镇', '凤岗镇', 3, '441900', '114.105', '22.7308');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (353, 346, '东莞生态园', '东莞生态园', 3, '441900', '113.917', '23.0806');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (354, 346, '桥头镇', '桥头镇', 3, '441900', '114.065', '23.0315');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (355, 346, '松山湖管委会', '松山湖管委会', 3, '441900', '113.875', '22.869');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (356, 346, '樟木头镇', '樟木头镇', 3, '441900', '114.018', '22.8704');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (357, 346, '石龙镇', '石龙镇', 3, '441900', '113.833', '23.1123');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (358, 346, '塘厦镇', '塘厦镇', 3, '441900', '114.05', '22.7713');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (359, 346, '寮步镇', '寮步镇', 3, '441900', '113.888', '22.9529');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (360, 346, '高埗镇', '高埗镇', 3, '441900', '113.773', '23.112');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (361, 346, '厚街镇', '厚街镇', 3, '441900', '113.776', '22.9097');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (362, 346, '谢岗镇', '谢岗镇', 3, '441900', '114.128', '22.9901');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (363, 346, '虎门镇', '虎门镇', 3, '441900', '113.797', '22.8587');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (364, 346, '虎门港管委会', '虎门港管委会', 3, '441900', '113.562', '22.9718');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (365, 346, '南城街道', '南城街道', 3, '441900', '113.737', '23.0249');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (366, 346, '横沥镇', '横沥镇', 3, '441900', '114.006', '23.0504');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (367, 346, '企石镇', '企石镇', 3, '441900', '113.99', '23.0541');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (368, 346, '东坑镇', '东坑镇', 3, '441900', '113.918', '22.995');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (369, 346, '东城街道', '东城街道', 3, '441900', '113.757', '23.0485');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (370, 346, '石排镇', '石排镇', 3, '441900', '113.988', '23.068');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (371, 346, '洪梅镇', '洪梅镇', 3, '441900', '113.607', '23.0155');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (372, 346, '沙田镇', '沙田镇', 3, '441900', '113.582', '22.9426');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (373, 346, '道滘镇', '道滘镇', 3, '441900', '113.692', '23.004');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (374, 346, '大岭山镇', '大岭山镇', 3, '441900', '113.843', '22.9534');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (375, 346, '清溪镇', '清溪镇', 3, '441900', '114.11', '22.862');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (376, 346, '茶山镇', '茶山镇', 3, '441900', '113.839', '23.0813');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (377, 346, '石碣镇', '石碣镇', 3, '441900', '113.846', '23.1024');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (378, 346, '中堂镇', '中堂镇', 3, '441900', '113.734', '23.1164');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (379, 346, '万江街道', '万江街道', 3, '441900', '113.709', '23.0014');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (380, 346, '长安镇', '长安镇', 3, '441900', '113.714', '22.7863');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (381, 346, '黄江镇', '黄江镇', 3, '441900', '113.977', '22.8091');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (382, 192, '广州市', '广州市', 2, '440100', '113.264499', '23.130061');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (383, 382, '从化区', '从化区', 3, '440117', '113.586329', '23.54915');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (384, 382, '花都区', '花都区', 3, '440114', '113.220125', '23.404326');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (385, 382, '南沙区', '南沙区', 3, '440115', '113.525178', '22.801435');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (386, 382, '海珠区', '海珠区', 3, '440105', '113.317412', '23.084003');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (387, 382, '番禺区', '番禺区', 3, '440113', '113.383917', '22.93756');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (388, 382, '增城区', '增城区', 3, '440118', '113.810734', '23.261452');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (389, 382, '黄埔区', '黄埔区', 3, '440112', '113.480613', '23.181355');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (390, 382, '天河区', '天河区', 3, '440106', '113.361597', '23.124817');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (391, 382, '白云区', '白云区', 3, '440111', '113.2732', '23.157159');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (392, 382, '越秀区', '越秀区', 3, '440104', '113.267065', '23.128673');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (393, 382, '荔湾区', '荔湾区', 3, '440103', '113.218998', '23.107123');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (394, 0, '内蒙古自治区', '内蒙古自治区', 1, '150000', '111.765226', '40.818233');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (395, 394, '乌海市', '乌海市', 2, '150300', '106.79415', '39.655048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (396, 395, '乌达区', '乌达区', 3, '150304', '106.726043', '39.505609');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (397, 395, '海南区', '海南区', 3, '150303', '106.891472', '39.441803');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (398, 395, '海勃湾区', '海勃湾区', 3, '150302', '106.8228', '39.690873');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (399, 394, '呼伦贝尔市', '呼伦贝尔市', 2, '150700', '119.77845', '49.166536');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (400, 399, '额尔古纳市', '额尔古纳市', 3, '150784', '120.180506', '50.243102');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (401, 399, '根河市', '根河市', 3, '150785', '121.520165', '50.779758');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (402, 399, '牙克石市', '牙克石市', 3, '150782', '120.711639', '49.285947');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (403, 399, '陈巴尔虎旗', '陈巴尔虎旗', 3, '150725', '119.424026', '49.328916');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (404, 399, '鄂温克族自治旗', '鄂温克族自治旗', 3, '150724', '119.755253', '49.146692');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (405, 399, '阿荣旗', '阿荣旗', 3, '150721', '123.458943', '48.126553');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (406, 399, '海拉尔区', '海拉尔区', 3, '150702', '119.824542', '49.234715');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (407, 399, '扎兰屯市', '扎兰屯市', 3, '150783', '122.708475', '48.028396');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (408, 399, '扎赉诺尔区', '扎赉诺尔区', 3, '150703', '117.669939', '49.511213');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (409, 399, '新巴尔虎左旗', '新巴尔虎左旗', 3, '150726', '118.269782', '48.21827');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (410, 399, '新巴尔虎右旗', '新巴尔虎右旗', 3, '150727', '116.8237', '48.671865');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (411, 399, '满洲里市', '满洲里市', 3, '150781', '117.379134', '49.59862');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (412, 399, '鄂伦春自治旗', '鄂伦春自治旗', 3, '150723', '123.725643', '50.591604');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (413, 399, '莫力达瓦达斡尔族自治旗', '莫力达瓦达斡尔族自治旗', 3, '150722', '124.519023', '48.477728');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (414, 394, '巴彦淖尔市', '巴彦淖尔市', 2, '150800', '107.387767', '40.742987');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (415, 414, '乌拉特中旗', '乌拉特中旗', 3, '150824', '108.513653', '41.58813');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (416, 414, '临河区', '临河区', 3, '150802', '107.363536', '40.750969');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (417, 414, '五原县', '五原县', 3, '150821', '108.267466', '41.088446');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (418, 414, '磴口县', '磴口县', 3, '150822', '107.008288', '40.330534');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (419, 414, '乌拉特前旗', '乌拉特前旗', 3, '150823', '108.652114', '40.737018');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (420, 414, '乌拉特后旗', '乌拉特后旗', 3, '150825', '107.074748', '41.08412');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (421, 414, '杭锦后旗', '杭锦后旗', 3, '150826', '107.151296', '40.886596');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (422, 394, '包头市', '包头市', 2, '150200', '109.95315', '40.621327');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (423, 422, '白云鄂博矿区', '白云鄂博矿区', 3, '150206', '109.973076', '41.769701');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (424, 422, '土默特右旗', '土默特右旗', 3, '150221', '110.527831', '40.578253');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (425, 422, '达尔罕茂明安联合旗', '达尔罕茂明安联合旗', 3, '150223', '110.432626', '41.698992');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (426, 422, '固阳县', '固阳县', 3, '150222', '110.060055', '41.034757');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (427, 422, '昆都仑区', '昆都仑区', 3, '150203', '109.840249', '40.658075');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (428, 422, '石拐区', '石拐区', 3, '150205', '110.060783', '40.676736');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (429, 422, '东河区', '东河区', 3, '150202', '110.044008', '40.57626');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (430, 422, '青山区', '青山区', 3, '150204', '109.902157', '40.644081');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (431, 422, '九原区', '九原区', 3, '150207', '109.968082', '40.611346');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (432, 394, '阿拉善盟', '阿拉善盟', 2, '152900', '105.729135', '38.851554');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (433, 432, '额济纳旗', '额济纳旗', 3, '152923', '101.055861', '41.953963');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (434, 432, '阿拉善右旗', '阿拉善右旗', 3, '152922', '101.666917', '39.216185');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (435, 432, '阿拉善左旗', '阿拉善左旗', 3, '152921', '105.666208', '38.833589');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (436, 394, '通辽市', '通辽市', 2, '150500', '122.243309', '43.653566');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (437, 436, '霍林郭勒市', '霍林郭勒市', 3, '150581', '119.681242', '45.533598');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (438, 436, '扎鲁特旗', '扎鲁特旗', 3, '150526', '120.917953', '44.567093');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (439, 436, '科尔沁左翼中旗', '科尔沁左翼中旗', 3, '150521', '123.312202', '44.126606');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (440, 436, '开鲁县', '开鲁县', 3, '150523', '121.319216', '43.601446');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (441, 436, '库伦旗', '库伦旗', 3, '150524', '121.810629', '42.735556');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (442, 436, '科尔沁区', '科尔沁区', 3, '150502', '122.25545', '43.623133');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (443, 436, '奈曼旗', '奈曼旗', 3, '150525', '120.657813', '42.867433');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (444, 436, '科尔沁左翼后旗', '科尔沁左翼后旗', 3, '150522', '122.35677', '42.935105');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (445, 394, '兴安盟', '兴安盟', 2, '152200', '122.037796', '46.082373');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (446, 445, '突泉县', '突泉县', 3, '152224', '121.593972', '45.381918');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (447, 445, '科尔沁右翼中旗', '科尔沁右翼中旗', 3, '152222', '121.476357', '45.060728');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (448, 445, '阿尔山市', '阿尔山市', 3, '152202', '119.943577', '47.17744');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (449, 445, '科尔沁右翼前旗', '科尔沁右翼前旗', 3, '152221', '121.952638', '46.079664');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (450, 445, '扎赉特旗', '扎赉特旗', 3, '152223', '122.899627', '46.723154');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (451, 445, '乌兰浩特市', '乌兰浩特市', 3, '152201', '122.093309', '46.072233');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (452, 394, '锡林郭勒盟', '锡林郭勒盟', 2, '152500', '116.047387', '43.933212');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (453, 452, '东乌珠穆沁旗', '东乌珠穆沁旗', 3, '152525', '116.97526', '45.497329');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (454, 452, '西乌珠穆沁旗', '西乌珠穆沁旗', 3, '152526', '117.608668', '44.587746');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (455, 452, '锡林浩特市', '锡林浩特市', 3, '152502', '116.085814', '43.933417');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (456, 452, '苏尼特左旗', '苏尼特左旗', 3, '152523', '113.667171', '43.859718');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (457, 452, '阿巴嘎旗', '阿巴嘎旗', 3, '152522', '114.950185', '44.022831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (458, 452, '苏尼特右旗', '苏尼特右旗', 3, '152524', '112.641806', '42.742417');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (459, 452, '正镶白旗', '正镶白旗', 3, '152529', '115.029748', '42.287493');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (460, 452, '二连浩特市', '二连浩特市', 3, '152501', '111.949594', '43.64285');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (461, 452, '正蓝旗', '正蓝旗', 3, '152530', '115.991648', '42.241815');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (462, 452, '镶黄旗', '镶黄旗', 3, '152528', '113.847287', '42.232371');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (463, 452, '太仆寺旗', '太仆寺旗', 3, '152527', '115.283173', '41.876889');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (464, 452, '多伦县', '多伦县', 3, '152531', '116.485549', '42.203454');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (465, 394, '呼和浩特市', '呼和浩特市', 2, '150100', '111.748814', '40.842127');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (466, 465, '和林格尔县', '和林格尔县', 3, '150123', '111.821695', '40.379226');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (467, 465, '回民区', '回民区', 3, '150103', '111.623485', '40.808906');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (468, 465, '玉泉区', '玉泉区', 3, '150104', '111.674157', '40.753054');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (469, 465, '托克托县', '托克托县', 3, '150122', '111.193879', '40.277703');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (470, 465, '土默特左旗', '土默特左旗', 3, '150121', '111.16373', '40.729044');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (471, 465, '武川县', '武川县', 3, '150125', '111.451226', '41.096511');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (472, 465, '新城区', '新城区', 3, '150102', '111.665325', '40.858271');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (473, 465, '赛罕区', '赛罕区', 3, '150105', '111.701166', '40.792508');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (474, 465, '清水河县', '清水河县', 3, '150124', '111.647351', '39.921224');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (475, 394, '乌兰察布市', '乌兰察布市', 2, '150900', '113.132227', '40.994526');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (476, 475, '四子王旗', '四子王旗', 3, '150929', '111.706663', '41.533542');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (477, 475, '化德县', '化德县', 3, '150922', '114.01029', '41.904123');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (478, 475, '察哈尔右翼后旗', '察哈尔右翼后旗', 3, '150928', '113.191505', '41.435937');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (479, 475, '商都县', '商都县', 3, '150923', '113.577778', '41.562176');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (480, 475, '察哈尔右翼中旗', '察哈尔右翼中旗', 3, '150927', '112.635348', '41.277449');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (481, 475, '兴和县', '兴和县', 3, '150924', '113.834176', '40.8723');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (482, 475, '卓资县', '卓资县', 3, '150921', '112.577716', '40.894618');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (483, 475, '丰镇市', '丰镇市', 3, '150981', '113.109875', '40.437022');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (484, 475, '集宁区', '集宁区', 3, '150902', '113.168973', '41.000742');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (485, 475, '察哈尔右翼前旗', '察哈尔右翼前旗', 3, '150926', '113.212409', '40.783551');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (486, 475, '凉城县', '凉城县', 3, '150925', '112.504243', '40.532358');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (487, 394, '鄂尔多斯市', '鄂尔多斯市', 2, '150600', '109.782473', '39.608744');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (488, 487, '达拉特旗', '达拉特旗', 3, '150621', '110.034133', '40.412766');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (489, 487, '杭锦旗', '杭锦旗', 3, '150625', '108.736011', '39.833243');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (490, 487, '鄂托克旗', '鄂托克旗', 3, '150624', '107.975948', '39.089549');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (491, 487, '乌审旗', '乌审旗', 3, '150626', '108.819485', '38.60453');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (492, 487, '鄂托克前旗', '鄂托克前旗', 3, '150623', '107.47733', '38.182402');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (493, 487, '康巴什区', '康巴什区', 3, '150603', '109.858586', '39.60793');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (494, 487, '伊金霍洛旗', '伊金霍洛旗', 3, '150627', '109.747435', '39.565064');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (495, 487, '东胜区', '东胜区', 3, '150602', '109.963403', '39.823066');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (496, 487, '准格尔旗', '准格尔旗', 3, '150622', '111.239436', '39.864923');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (497, 394, '赤峰市', '赤峰市', 2, '150400', '118.887613', '42.256876');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (498, 497, '阿鲁科尔沁旗', '阿鲁科尔沁旗', 3, '150421', '120.065533', '43.872398');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (499, 497, '巴林右旗', '巴林右旗', 3, '150423', '118.664235', '43.534171');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (500, 497, '林西县', '林西县', 3, '150424', '118.05545', '43.61812');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (501, 497, '巴林左旗', '巴林左旗', 3, '150422', '119.362832', '43.961547');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (502, 497, '松山区', '松山区', 3, '150404', '118.916156', '42.299795');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (503, 497, '红山区', '红山区', 3, '150402', '118.953989', '42.296317');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (504, 497, '喀喇沁旗', '喀喇沁旗', 3, '150428', '118.701934', '41.927103');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (505, 497, '敖汉旗', '敖汉旗', 3, '150430', '119.921413', '42.290731');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (506, 497, '宁城县', '宁城县', 3, '150429', '119.320056', '41.600193');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (507, 497, '元宝山区', '元宝山区', 3, '150403', '119.288475', '42.039602');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (508, 497, '克什克腾旗', '克什克腾旗', 3, '150425', '117.545413', '43.265057');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (509, 497, '翁牛特旗', '翁牛特旗', 3, '150426', '119.006187', '42.936529');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (510, 0, '黑龙江省', '黑龙江省', 1, '230000', '126.661998', '45.742253');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (511, 510, '七台河市', '七台河市', 2, '230900', '131.003015', '45.771178');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (512, 511, '桃山区', '桃山区', 3, '230903', '131.020046', '45.765733');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (513, 511, '茄子河区', '茄子河区', 3, '230904', '131.067545', '45.785755');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (514, 511, '勃利县', '勃利县', 3, '230921', '130.592009', '45.755856');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (515, 511, '新兴区', '新兴区', 3, '230902', '130.93226', '45.816579');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (516, 510, '鹤岗市', '鹤岗市', 2, '230400', '130.297687', '47.350659');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (517, 516, '绥滨县', '绥滨县', 3, '230422', '131.852863', '47.289522');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (518, 516, '工农区', '工农区', 3, '230403', '130.27472', '47.318971');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (519, 516, '向阳区', '向阳区', 3, '230402', '130.294331', '47.342478');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (520, 516, '兴山区', '兴山区', 3, '230407', '130.303598', '47.357698');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (521, 516, '南山区', '南山区', 3, '230404', '130.285991', '47.315121');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (522, 516, '萝北县', '萝北县', 3, '230421', '130.820566', '47.578979');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (523, 516, '东山区', '东山区', 3, '230406', '130.317151', '47.338571');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (524, 516, '兴安区', '兴安区', 3, '230405', '130.239289', '47.252805');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (525, 510, '大兴安岭地区', '大兴安岭地区', 2, '232700', '124.117806', '50.411048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (526, 525, '漠河市', '漠河市', 3, '232701', '122.539313', '52.972465');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (527, 525, '呼玛县', '呼玛县', 3, '232721', '126.651856', '51.725924');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (528, 525, '塔河县', '塔河县', 3, '232722', '124.709733', '52.334512');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (529, 525, '加格达奇区', '加格达奇区', 3, '232718', '124.139742', '50.408822');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (530, 510, '伊春市', '伊春市', 2, '230700', '128.840863', '47.728332');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (531, 530, '嘉荫县', '嘉荫县', 3, '230722', '130.402406', '48.888613');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (532, 530, '友好区', '友好区', 3, '230719', '128.836341', '47.840801');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (533, 530, '伊美区', '伊美区', 3, '230717', '128.907156', '47.728257');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (534, 530, '乌翠区', '乌翠区', 3, '230718', '128.669458', '47.726499');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (535, 530, '汤旺县', '汤旺县', 3, '230723', '129.570935', '48.454639');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (536, 530, '丰林县', '丰林县', 3, '230724', '129.533661', '48.290566');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (537, 530, '金林区', '金林区', 3, '230751', '129.428839', '47.413019');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (538, 530, '铁力市', '铁力市', 3, '230781', '128.032554', '46.986604');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (539, 530, '南岔县', '南岔县', 3, '230726', '129.283467', '47.138034');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (540, 530, '大箐山县', '大箐山县', 3, '230725', '129.020597', '47.02836');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (541, 510, '哈尔滨市', '哈尔滨市', 2, '230100', '126.53505', '45.802981');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (542, 541, '巴彦县', '巴彦县', 3, '230126', '127.403521', '46.086182');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (543, 541, '依兰县', '依兰县', 3, '230123', '129.567777', '46.325536');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (544, 541, '宾县', '宾县', 3, '230125', '127.466372', '45.746313');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (545, 541, '木兰县', '木兰县', 3, '230127', '128.043194', '45.950649');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (546, 541, '通河县', '通河县', 3, '230128', '128.74629', '45.990214');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (547, 541, '方正县', '方正县', 3, '230124', '128.829513', '45.851673');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (548, 541, '双城区', '双城区', 3, '230113', '126.31279', '45.382873');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (549, 541, '平房区', '平房区', 3, '230108', '126.63675', '45.597529');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (550, 541, '延寿县', '延寿县', 3, '230129', '128.311071', '45.445956');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (551, 541, '尚志市', '尚志市', 3, '230183', '128.009218', '45.209199');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (552, 541, '香坊区', '香坊区', 3, '230110', '126.662959', '45.707871');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (553, 541, '道里区', '道里区', 3, '230102', '126.616912', '45.755832');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (554, 541, '五常市', '五常市', 3, '230184', '127.167501', '44.932164');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (555, 541, '阿城区', '阿城区', 3, '230112', '126.957984', '45.548671');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (556, 541, '呼兰区', '呼兰区', 3, '230111', '126.587704', '45.889557');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (557, 541, '松北区', '松北区', 3, '230109', '126.516602', '45.794991');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (558, 541, '道外区', '道外区', 3, '230104', '126.649094', '45.792351');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (559, 541, '南岗区', '南岗区', 3, '230103', '126.66882', '45.759967');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (560, 510, '绥化市', '绥化市', 2, '231200', '126.968714', '46.654147');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (561, 560, '绥棱县', '绥棱县', 3, '231226', '127.114928', '47.235814');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (562, 560, '海伦市', '海伦市', 3, '231283', '126.930191', '47.450661');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (563, 560, '庆安县', '庆安县', 3, '231224', '127.507586', '46.880628');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (564, 560, '望奎县', '望奎县', 3, '231221', '126.486333', '46.832185');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (565, 560, '青冈县', '青冈县', 3, '231223', '126.099314', '46.70398');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (566, 560, '北林区', '北林区', 3, '231202', '126.984995', '46.638114');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (567, 560, '兰西县', '兰西县', 3, '231222', '126.287734', '46.252966');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (568, 560, '明水县', '明水县', 3, '231225', '125.90601', '47.173649');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (569, 560, '肇东市', '肇东市', 3, '231282', '125.962419', '46.050664');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (570, 560, '安达市', '安达市', 3, '231281', '125.307629', '46.451882');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (571, 510, '鸡西市', '鸡西市', 2, '230300', '130.969385', '45.295087');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (572, 571, '麻山区', '麻山区', 3, '230307', '130.477691', '45.211863');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (573, 571, '城子河区', '城子河区', 3, '230306', '131.011504', '45.338342');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (574, 571, '鸡冠区', '鸡冠区', 3, '230302', '130.981342', '45.303892');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (575, 571, '梨树区', '梨树区', 3, '230305', '130.69699', '45.092046');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (576, 571, '滴道区', '滴道区', 3, '230304', '130.844193', '45.349068');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (577, 571, '恒山区', '恒山区', 3, '230303', '130.90466', '45.21119');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (578, 571, '密山市', '密山市', 3, '230382', '131.846824', '45.529482');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (579, 571, '鸡东县', '鸡东县', 3, '230321', '131.124083', '45.260413');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (580, 571, '虎林市', '虎林市', 3, '230381', '132.937002', '45.763262');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (581, 510, '大庆市', '大庆市', 2, '230600', '125.104078', '46.589498');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (582, 581, '让胡路区', '让胡路区', 3, '230604', '124.889858', '46.642567');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (583, 581, '红岗区', '红岗区', 3, '230605', '124.891041', '46.398567');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (584, 581, '肇源县', '肇源县', 3, '230622', '125.078311', '45.518982');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (585, 581, '大同区', '大同区', 3, '230606', '124.812221', '46.039972');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (586, 581, '林甸县', '林甸县', 3, '230623', '124.863628', '47.171677');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (587, 581, '杜尔伯特蒙古族自治县', '杜尔伯特蒙古族自治县', 3, '230624', '124.442829', '46.862348');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (588, 581, '萨尔图区', '萨尔图区', 3, '230602', '125.135269', '46.629281');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (589, 581, '龙凤区', '龙凤区', 3, '230603', '125.135093', '46.562369');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (590, 581, '肇州县', '肇州县', 3, '230621', '125.268449', '45.699543');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (591, 510, '佳木斯市', '佳木斯市', 2, '230800', '130.318916', '46.800002');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (592, 591, '同江市', '同江市', 3, '230881', '132.510113', '47.642475');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (593, 591, '桦川县', '桦川县', 3, '230826', '130.71908', '47.023001');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (594, 591, '汤原县', '汤原县', 3, '230828', '129.904747', '46.730623');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (595, 591, '郊区', '郊区', 3, '230811', '130.327182', '46.809596');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (596, 591, '东风区', '东风区', 3, '230805', '130.403588', '46.822609');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (597, 591, '前进区', '前进区', 3, '230804', '130.375254', '46.81405');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (598, 591, '向阳区', '向阳区', 3, '230803', '130.365263', '46.807808');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (599, 591, '桦南县', '桦南县', 3, '230822', '130.553472', '46.239314');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (600, 591, '抚远市', '抚远市', 3, '230883', '134.30786', '48.365027');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (601, 591, '富锦市', '富锦市', 3, '230882', '132.037659', '47.250144');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (602, 510, '双鸭山市', '双鸭山市', 2, '230500', '131.141563', '46.676157');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (603, 602, '尖山区', '尖山区', 3, '230502', '131.158372', '46.646083');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (604, 602, '友谊县', '友谊县', 3, '230522', '131.807815', '46.767299');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (605, 602, '宝山区', '宝山区', 3, '230506', '131.401589', '46.577167');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (606, 602, '岭东区', '岭东区', 3, '230503', '131.165067', '46.592663');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (607, 602, '宝清县', '宝清县', 3, '230523', '132.196907', '46.327335');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (608, 602, '饶河县', '饶河县', 3, '230524', '134.014125', '46.79726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (609, 602, '集贤县', '集贤县', 3, '230521', '131.141452', '46.728448');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (610, 602, '四方台区', '四方台区', 3, '230505', '131.337636', '46.597143');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (611, 510, '黑河市', '黑河市', 2, '231100', '127.528226', '50.244887');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (612, 611, '爱辉区', '爱辉区', 3, '231102', '127.500703', '50.252361');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (613, 611, '北安市', '北安市', 3, '231181', '126.490989', '48.241168');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (614, 611, '逊克县', '逊克县', 3, '231123', '128.478698', '49.56429');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (615, 611, '五大连池市', '五大连池市', 3, '231182', '126.205446', '48.517342');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (616, 611, '孙吴县', '孙吴县', 3, '231124', '127.336163', '49.425645');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (617, 611, '嫩江市', '嫩江市', 3, '231183', '125.221192', '49.185766');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (618, 510, '牡丹江市', '牡丹江市', 2, '231000', '129.632928', '44.551486');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (619, 618, '爱民区', '爱民区', 3, '231004', '129.591227', '44.595897');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (620, 618, '绥芬河市', '绥芬河市', 3, '231081', '131.151805', '44.412487');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (621, 618, '东安区', '东安区', 3, '231002', '129.626651', '44.58125');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (622, 618, '宁安市', '宁安市', 3, '231084', '129.482505', '44.340617');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (623, 618, '林口县', '林口县', 3, '231025', '130.282286', '45.279754');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (624, 618, '穆棱市', '穆棱市', 3, '231085', '130.52446', '44.918842');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (625, 618, '阳明区', '阳明区', 3, '231003', '129.635836', '44.595851');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (626, 618, '西安区', '西安区', 3, '231005', '129.616021', '44.577611');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (627, 618, '海林市', '海林市', 3, '231083', '129.380756', '44.594017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (628, 618, '东宁市', '东宁市', 3, '231086', '131.124839', '44.090361');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (629, 510, '齐齐哈尔市', '齐齐哈尔市', 2, '230200', '123.918193', '47.354892');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (630, 629, '甘南县', '甘南县', 3, '230225', '123.507935', '47.921698');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (631, 629, '富裕县', '富裕县', 3, '230227', '124.474411', '47.774038');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (632, 629, '克山县', '克山县', 3, '230229', '125.875103', '48.037748');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (633, 629, '克东县', '克东县', 3, '230230', '126.249124', '48.041562');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (634, 629, '依安县', '依安县', 3, '230223', '125.306161', '47.893442');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (635, 629, '梅里斯达斡尔族区', '梅里斯达斡尔族区', 3, '230208', '123.752482', '47.309755');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (636, 629, '铁锋区', '铁锋区', 3, '230204', '123.978079', '47.340719');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (637, 629, '龙江县', '龙江县', 3, '230221', '123.204953', '47.338512');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (638, 629, '富拉尔基区', '富拉尔基区', 3, '230206', '123.628926', '47.20873');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (639, 629, '碾子山区', '碾子山区', 3, '230207', '122.887548', '47.516614');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (640, 629, '龙沙区', '龙沙区', 3, '230202', '123.958447', '47.317103');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (641, 629, '建华区', '建华区', 3, '230203', '123.95555', '47.354212');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (642, 629, '昂昂溪区', '昂昂溪区', 3, '230205', '123.822137', '47.154806');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (643, 629, '泰来县', '泰来县', 3, '230224', '123.416631', '46.393694');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (644, 629, '拜泉县', '拜泉县', 3, '230231', '126.09905', '47.59586');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (645, 629, '讷河市', '讷河市', 3, '230281', '124.88293', '48.466829');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (646, 0, '新疆维吾尔自治区', '新疆维吾尔自治区', 1, '650000', '87.628579', '43.793301');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (647, 646, '铁门关市', '铁门关市', 2, '659006', '85.670291', '41.862997');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (648, 647, '博古其镇', '博古其镇', 3, '659006', '85.5849', '41.8825');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (649, 647, '双丰镇', '双丰镇', 3, '659006', '85.5849', '41.8825');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (650, 646, '双河市', '双河市', 2, '659007', '82.367887', '44.845935');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (651, 650, '兵团八十九团', '兵团八十九团', 3, '659007', '82.2853', '45.0582');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (652, 650, '博河镇', '博河镇', 3, '659007', '82.1787', '44.8089');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (653, 650, '石峪镇', '石峪镇', 3, '659007', '82.215', '45.1246');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (654, 650, '双乐镇', '双乐镇', 3, '659007', '82.6473', '44.7651');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (655, 650, '双桥镇', '双桥镇', 3, '659007', '82.4908', '44.7469');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (656, 646, '和田地区', '和田地区', 2, '653200', '79.921646', '37.114406');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (657, 656, '于田县', '于田县', 3, '653226', '81.677417', '36.85708');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (658, 656, '民丰县', '民丰县', 3, '653227', '82.695946', '37.064428');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (659, 656, '和田市', '和田市', 3, '653201', '79.912881', '37.112246');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (660, 656, '和田县', '和田县', 3, '653221', '79.81906982', '37.12003092');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (661, 656, '墨玉县', '墨玉县', 3, '653222', '79.728434', '37.277518');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (662, 656, '洛浦县', '洛浦县', 3, '653224', '80.179911', '37.066226');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (663, 656, '皮山县', '皮山县', 3, '653223', '78.28548', '37.578264');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (664, 656, '策勒县', '策勒县', 3, '653225', '80.801433', '36.99785');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (665, 646, '博尔塔拉蒙古自治州', '博尔塔拉蒙古自治州', 2, '652700', '82.066363', '44.906039');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (666, 665, '温泉县', '温泉县', 3, '652723', '81.024827', '44.968857');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (667, 665, '阿拉山口市', '阿拉山口市', 3, '652702', '82.554609', '45.173274');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (668, 665, '精河县', '精河县', 3, '652722', '82.890709', '44.599202');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (669, 665, '博乐市', '博乐市', 3, '652701', '82.051433', '44.853882');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (670, 646, '昆玉市', '昆玉市', 2, '659009', '79.270193', '37.215372');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (671, 670, '乌尔其乡', '乌尔其乡', 3, '659009', '79.5866', '37.332');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (672, 670, '博斯坦乡', '博斯坦乡', 3, '659009', '81.3298', '36.4124');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (673, 670, '阔依其乡', '阔依其乡', 3, '659009', '79.6876', '37.3691');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (674, 670, '兵团二二四团', '兵团二二四团', 3, '659009', '79.3401', '37.416');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (675, 670, '昆牧镇', '昆牧镇', 3, '659009', '81.0295', '36.3152');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (676, 670, '喀拉喀什镇', '喀拉喀什镇', 3, '659009', '79.7678', '37.2867');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (677, 670, '昆泉镇', '昆泉镇', 3, '659009', '78.5171', '37.563');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (678, 670, '普恰克其乡', '普恰克其乡', 3, '659009', '79.783', '37.5805');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (679, 670, '奴尔乡', '奴尔乡', 3, '659009', '81.0072', '36.2605');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (680, 670, '老兵镇', '老兵镇', 3, '659009', '79.6039', '37.3666');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (681, 670, '乌鲁克萨依乡', '乌鲁克萨依乡', 3, '659009', '80.8148', '36.2925');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (682, 646, '塔城地区', '塔城地区', 2, '654200', '82.980316', '46.745364');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (683, 682, '塔城市', '塔城市', 3, '654201', '82.986923', '46.751669');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (684, 682, '额敏县', '额敏县', 3, '654221', '83.628303', '46.524673');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (685, 682, '和布克赛尔蒙古自治县', '和布克赛尔蒙古自治县', 3, '654226', '85.728328', '46.793235');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (686, 682, '裕民县', '裕民县', 3, '654225', '82.982252', '46.201049');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (687, 682, '托里县', '托里县', 3, '654224', '83.606372', '45.948935');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (688, 682, '乌苏市', '乌苏市', 3, '654202', '84.713762', '44.418693');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (689, 682, '沙湾市', '沙湾市', 3, '654223', '85.619483', '44.326267');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (690, 646, '可克达拉市', '可克达拉市', 2, '659008', '80.994153', '43.940381');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (691, 690, '长丰镇', '长丰镇', 3, '659008', '80.9903', '43.8897');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (692, 690, '都拉塔口岸', '都拉塔口岸', 3, '659008', '80.6882', '43.7131');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (693, 690, '兵团六十七团', '兵团六十七团', 3, '659008', '80.6068', '43.7652');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (694, 690, '兵团六十六团', '兵团六十六团', 3, '659008', '81.086', '43.9599');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (695, 690, '榆树庄镇', '榆树庄镇', 3, '659008', '80.4844', '43.931');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (696, 690, '苇湖镇', '苇湖镇', 3, '659008', '80.6749', '44.0986');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (697, 646, '北屯市', '北屯市', 2, '659005', '87.834419', '47.326733');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (698, 697, '丰庆镇', '丰庆镇', 3, '659005', '87.761', '47.1948');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (699, 697, '海川镇', '海川镇', 3, '659005', '87.5186', '47.4099');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (700, 697, '双渠镇', '双渠镇', 3, '659005', '88.1187', '47.1285');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (701, 697, '北屯镇', '北屯镇', 3, '659005', '87.7224', '47.4017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (702, 646, '石河子市', '石河子市', 2, '659001', '86.080397', '44.305368');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (703, 702, '兵团一五二团', '兵团一五二团', 3, '659001', '86.0704', '44.2827');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (704, 702, '向阳街道', '向阳街道', 3, '659001', '86.0397', '44.3429');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (705, 702, '红山街道', '红山街道', 3, '659001', '86.048', '44.2682');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (706, 702, '东城街道', '东城街道', 3, '659001', '86.0687', '44.2873');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (707, 702, '石河子镇', '石河子镇', 3, '659001', '86.1022', '44.1352');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (708, 702, '老街街道', '老街街道', 3, '659001', '85.9909', '44.3496');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (709, 702, '新城街道', '新城街道', 3, '659001', '85.9823', '44.2893');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (710, 702, '北泉镇', '北泉镇', 3, '659001', '86.0983', '44.4346');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (711, 646, '阿勒泰地区', '阿勒泰地区', 2, '654300', '88.141253', '47.844924');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (712, 711, '布尔津县', '布尔津县', 3, '654321', '86.875043', '47.701892');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (713, 711, '富蕴县', '富蕴县', 3, '654322', '89.525463', '46.994046');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (714, 711, '哈巴河县', '哈巴河县', 3, '654324', '86.418621', '48.060846');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (715, 711, '吉木乃县', '吉木乃县', 3, '654326', '85.874096', '47.443101');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (716, 711, '青河县', '青河县', 3, '654325', '90.375159', '46.678532');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (717, 711, '阿勒泰市', '阿勒泰市', 3, '654301', '88.131842', '47.827308');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (718, 711, '福海县', '福海县', 3, '654323', '87.486703', '47.111918');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (719, 646, '昌吉回族自治州', '昌吉回族自治州', 2, '652300', '87.308995', '44.011044');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (720, 719, '玛纳斯县', '玛纳斯县', 3, '652324', '86.20488', '44.284601');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (721, 719, '奇台县', '奇台县', 3, '652325', '89.593879', '44.022001');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (722, 719, '呼图壁县', '呼图壁县', 3, '652323', '86.871532', '44.179362');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (723, 719, '木垒哈萨克自治县', '木垒哈萨克自治县', 3, '652328', '90.286013', '43.834631');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (724, 719, '阜康市', '阜康市', 3, '652302', '87.953826', '44.164525');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (725, 719, '昌吉市', '昌吉市', 3, '652301', '87.267432', '44.014468');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (726, 719, '吉木萨尔县', '吉木萨尔县', 3, '652327', '89.179698', '44.000404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (727, 646, '五家渠市', '五家渠市', 2, '659004', '87.542852', '44.166489');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (728, 727, '梧桐镇', '梧桐镇', 3, '659004', '87.5925', '44.2694');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (729, 727, '军垦路街道', '军垦路街道', 3, '659004', '87.5084', '44.1889');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (730, 727, '人民路街道', '人民路街道', 3, '659004', '87.5728', '44.1822');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (731, 727, '兵团一零一团', '兵团一零一团', 3, '659004', '87.5562', '44.1752');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (732, 727, '蔡家湖镇', '蔡家湖镇', 3, '659004', '87.4075', '44.5317');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (733, 727, '青湖路街道', '青湖路街道', 3, '659004', '87.5245', '44.1764');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (734, 646, '伊犁哈萨克自治州', '伊犁哈萨克自治州', 2, '654000', '81.323691', '43.917106');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (735, 734, '奎屯市', '奎屯市', 3, '654003', '84.903216', '44.426452');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (736, 734, '巩留县', '巩留县', 3, '654024', '82.231219', '43.48313');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (737, 734, '伊宁县', '伊宁县', 3, '654021', '81.52745', '43.977119');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (738, 734, '尼勒克县', '尼勒克县', 3, '654028', '82.511884', '43.798627');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (739, 734, '新源县', '新源县', 3, '654025', '83.233002', '43.434803');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (740, 734, '察布查尔锡伯自治县', '察布查尔锡伯自治县', 3, '654022', '81.151337', '43.840726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (741, 734, '昭苏县', '昭苏县', 3, '654026', '81.130974', '43.157293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (742, 734, '霍城县', '霍城县', 3, '654023', '80.878845', '44.056329');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (743, 734, '特克斯县', '特克斯县', 3, '654027', '81.835732', '43.218435');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (744, 734, '霍尔果斯市', '霍尔果斯市', 3, '654004', '80.414614', '44.218381');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (745, 734, '伊宁市', '伊宁市', 3, '654002', '81.277715', '43.908021');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (746, 646, '喀什地区', '喀什地区', 2, '653100', '75.989746', '39.470492');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (747, 746, '伽师县', '伽师县', 3, '653129', '76.723719', '39.488181');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (748, 746, '疏勒县', '疏勒县', 3, '653122', '76.047169', '39.401173');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (749, 746, '泽普县', '泽普县', 3, '653124', '77.260375', '38.184639');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (750, 746, '叶城县', '叶城县', 3, '653126', '77.413669', '37.882994');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (751, 746, '麦盖提县', '麦盖提县', 3, '653127', '77.609099', '38.898986');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (752, 746, '塔什库尔干塔吉克自治县', '塔什库尔干塔吉克自治县', 3, '653131', '75.229889', '37.772094');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (753, 746, '莎车县', '莎车县', 3, '653125', '77.223197', '38.390881');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (754, 746, '巴楚县', '巴楚县', 3, '653130', '78.54799', '39.79923');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (755, 746, '疏附县', '疏附县', 3, '653121', '75.862839', '39.375052');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (756, 746, '英吉沙县', '英吉沙县', 3, '653123', '76.175729', '38.930381');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (757, 746, '喀什市', '喀什市', 3, '653101', '75.993936', '39.46823');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (758, 746, '岳普湖县', '岳普湖县', 3, '653128', '76.821269', '39.219857');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (759, 646, '图木舒克市', '图木舒克市', 2, '659003', '79.074762', '39.868366');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (760, 759, '兵团四十九团', '兵团四十九团', 3, '659003', '78.756', '39.8224');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (761, 759, '兵团图木舒克市永安坝', '兵团图木舒克市永安坝', 3, '659003', '79.0133', '39.8385');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (762, 759, '兵团五十一团', '兵团五十一团', 3, '659003', '79.2902', '39.9888');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (763, 759, '前海街道', '前海街道', 3, '659003', '79.0778', '39.855');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (764, 759, '兵团图木舒克市喀拉拜勒镇', '兵团图木舒克市喀拉拜勒镇', 3, '659003', '79.0112', '39.8526');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (765, 759, '永安坝街道', '永安坝街道', 3, '659003', '79.0229', '39.8507');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (766, 759, '齐干却勒街道', '齐干却勒街道', 3, '659003', '79.0906', '39.8753');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (767, 759, '兵团五十三团', '兵团五十三团', 3, '659003', '79.3214', '40.0318');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (768, 759, '夏河镇', '夏河镇', 3, '659003', '79.2315', '39.9549');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (769, 759, '兵团四十四团', '兵团四十四团', 3, '659003', '79.1926', '39.9168');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (770, 646, '巴音郭楞蒙古自治州', '巴音郭楞蒙古自治州', 2, '652800', '86.145298', '41.764115');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (771, 770, '和静县', '和静县', 3, '652827', '86.384065', '42.323625');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (772, 770, '博湖县', '博湖县', 3, '652829', '86.632116', '41.980745');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (773, 770, '和硕县', '和硕县', 3, '652828', '86.877688', '42.28361');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (774, 770, '焉耆回族自治县', '焉耆回族自治县', 3, '652826', '86.57434', '42.059509');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (775, 770, '且末县', '且末县', 3, '652825', '85.529619', '38.145749');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (776, 770, '若羌县', '若羌县', 3, '652824', '88.167226', '39.022626');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (777, 770, '轮台县', '轮台县', 3, '652822', '84.251508', '41.778043');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (778, 770, '库尔勒市', '库尔勒市', 3, '652801', '86.174633', '41.725891');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (779, 770, '尉犁县', '尉犁县', 3, '652823', '86.261613', '41.343871');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (780, 646, '阿克苏地区', '阿克苏地区', 2, '652900', '80.265068', '41.170712');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (781, 780, '新和县', '新和县', 3, '652925', '82.620371', '41.552097');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (782, 780, '温宿县', '温宿县', 3, '652922', '80.243273', '41.272995');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (783, 780, '拜城县', '拜城县', 3, '652926', '81.851289', '41.795289');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (784, 780, '沙雅县', '沙雅县', 3, '652924', '82.781774', '41.221413');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (785, 780, '库车市', '库车市', 3, '652902', '82.998544', '41.719073');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (786, 780, '阿克苏市', '阿克苏市', 3, '652901', '80.290429', '41.185019');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (787, 780, '柯坪县', '柯坪县', 3, '652929', '79.054019', '40.501645');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (788, 780, '阿瓦提县', '阿瓦提县', 3, '652928', '80.375053', '40.643647');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (789, 780, '乌什县', '乌什县', 3, '652927', '79.22118', '41.222706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (790, 646, '乌鲁木齐市', '乌鲁木齐市', 2, '650100', '87.616824', '43.825377');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (791, 790, '达坂城区', '达坂城区', 3, '650107', '88.311099', '43.363668');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (792, 790, '天山区', '天山区', 3, '650102', '87.631986', '43.794312');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (793, 790, '米东区', '米东区', 3, '650109', '87.655122', '43.97444');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (794, 790, '水磨沟区', '水磨沟区', 3, '650105', '87.64208', '43.832714');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (795, 790, '头屯河区', '头屯河区', 3, '650106', '87.42582303', '43.87605225');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (796, 790, '乌鲁木齐县', '乌鲁木齐县', 3, '650121', '87.464257', '43.509016');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (797, 790, '沙依巴克区', '沙依巴克区', 3, '650103', '87.598043', '43.800994');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (798, 790, '新市区', '新市区', 3, '650104', '87.592684', '43.893023');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (799, 646, '阿拉尔市', '阿拉尔市', 2, '659002', '81.280532', '40.547205');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (800, 799, '幸福路街道', '幸福路街道', 3, '659002', '81.2681', '40.577');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (801, 799, '阿拉尔农场', '阿拉尔农场', 3, '659002', '81.0627', '40.5567');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (802, 799, '兵团第一师幸福农场', '兵团第一师幸福农场', 3, '659002', '80.9904', '40.7025');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (803, 799, '工业园区', '工业园区', 3, '659002', '81.2448', '40.5461');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (804, 799, '兵团七团', '兵团七团', 3, '659002', '80.6543', '40.6569');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (805, 799, '花桥镇', '花桥镇', 3, '659002', '81.5619', '40.6277');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (806, 799, '兵团第一师水利水电工程处', '兵团第一师水利水电工程处', 3, '659002', '81.2858', '40.5496');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (807, 799, '青松路街道', '青松路街道', 3, '659002', '81.2545', '40.542');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (808, 799, '托喀依乡', '托喀依乡', 3, '659002', '81.3541', '40.5818');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (809, 799, '兵团八团', '兵团八团', 3, '659002', '80.7996', '40.5973');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (810, 799, '中心监狱', '中心监狱', 3, '659002', '81.2766', '40.6692');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (811, 799, '兵团第一师塔里木灌区水利管理处', '兵团第一师塔里木灌区水利管理处', 3, '659002', '81.2876', '40.5454');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (812, 799, '金杨镇', '金杨镇', 3, '659002', '81.8688', '40.9423');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (813, 799, '南口街道', '南口街道', 3, '659002', '81.2988', '40.5154');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (814, 799, '幸福镇', '幸福镇', 3, '659002', '81.4734', '40.5742');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (815, 799, '兵团十团', '兵团十团', 3, '659002', '81.259', '40.6387');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (816, 799, '兵团十二团', '兵团十二团', 3, '659002', '81.1109', '40.4977');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (817, 799, '金银川路街道', '金银川路街道', 3, '659002', '81.2613', '40.5355');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (818, 799, '兵团十六团', '兵团十六团', 3, '659002', '80.7871', '40.4163');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (819, 646, '克孜勒苏柯尔克孜自治州', '克孜勒苏柯尔克孜自治州', 2, '653000', '76.167327', '39.714734');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (820, 819, '乌恰县', '乌恰县', 3, '653024', '75.259228', '39.7205');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (821, 819, '阿图什市', '阿图什市', 3, '653001', '76.167538', '39.716586');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (822, 819, '阿合奇县', '阿合奇县', 3, '653023', '78.402073', '40.937581');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (823, 819, '阿克陶县', '阿克陶县', 3, '653022', '75.947396', '39.147785');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (824, 646, '哈密市', '哈密市', 2, '650500', '93.515053', '42.819346');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (825, 824, '伊吾县', '伊吾县', 3, '650522', '94.697074', '43.254978');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (826, 824, '巴里坤哈萨克自治县', '巴里坤哈萨克自治县', 3, '650521', '93.016563', '43.598756');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (827, 824, '伊州区', '伊州区', 3, '650502', '93.515085', '42.827376');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (828, 646, '吐鲁番市', '吐鲁番市', 2, '650400', '89.190374', '42.950736');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (829, 828, '高昌区', '高昌区', 3, '650402', '89.185891', '42.942728');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (830, 828, '鄯善县', '鄯善县', 3, '650421', '90.242843', '42.900575');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (831, 828, '托克逊县', '托克逊县', 3, '650422', '88.643739', '42.802585');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (832, 646, '克拉玛依市', '克拉玛依市', 2, '650200', '84.889239', '45.577712');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (833, 832, '乌尔禾区', '乌尔禾区', 3, '650205', '85.692518', '46.085819');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (834, 832, '独山子区', '独山子区', 3, '650202', '84.886973', '44.328096');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (835, 832, '克拉玛依区', '克拉玛依区', 3, '650203', '84.867862', '45.602347');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (836, 832, '白碱滩区', '白碱滩区', 3, '650204', '85.119047', '45.685416');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (837, 646, '胡杨河市', '胡杨河市', 2, '659010', '84.827592', '44.692894');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (838, 837, '兵团一三零团', '兵团一三零团', 3, '659010', '84.8765', '44.6164');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (839, 837, '五五新镇街道', '五五新镇街道', 3, '659010', '84.8012', '44.865');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (840, 837, '兵团一二八团', '兵团一二八团', 3, '659010', '84.5572', '45.0861');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (841, 837, '兵团一二九团', '兵团一二九团', 3, '659010', '84.8046', '44.8465');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (842, 0, '湖北省', '湖北省', 1, '420000', '114.341552', '30.546222');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (843, 842, '宜昌市', '宜昌市', 2, '420500', '111.286962', '30.69217');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (844, 843, '兴山县', '兴山县', 3, '420526', '110.746831', '31.348065');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (845, 843, '秭归县', '秭归县', 3, '420527', '110.97793', '30.825882');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (846, 843, '当阳市', '当阳市', 3, '420582', '111.78836', '30.820893');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (847, 843, '长阳土家族自治县', '长阳土家族自治县', 3, '420528', '111.20697', '30.473038');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (848, 843, '点军区', '点军区', 3, '420504', '111.268338', '30.69343');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (849, 843, '伍家岗区', '伍家岗区', 3, '420503', '111.360882', '30.644048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (850, 843, '宜都市', '宜都市', 3, '420581', '111.450128', '30.378444');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (851, 843, '猇亭区', '猇亭区', 3, '420505', '111.434378', '30.531133');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (852, 843, '五峰土家族自治县', '五峰土家族自治县', 3, '420529', '111.07374', '30.156741');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (853, 843, '枝江市', '枝江市', 3, '420583', '111.760616', '30.425758');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (854, 843, '西陵区', '西陵区', 3, '420502', '111.285696', '30.710765');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (855, 843, '夷陵区', '夷陵区', 3, '420506', '111.326371', '30.769875');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (856, 843, '远安县', '远安县', 3, '420525', '111.640329', '31.060904');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (857, 842, '十堰市', '十堰市', 2, '420300', '110.798921', '32.629057');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (858, 857, '茅箭区', '茅箭区', 3, '420302', '110.813478', '32.591847');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (859, 857, '郧阳区', '郧阳区', 3, '420304', '110.812101', '32.834847');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (860, 857, '丹江口市', '丹江口市', 3, '420381', '111.513318', '32.540287');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (861, 857, '张湾区', '张湾区', 3, '420303', '110.769132', '32.652297');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (862, 857, '竹山县', '竹山县', 3, '420323', '110.229696', '32.225039');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (863, 857, '房县', '房县', 3, '420325', '110.726754', '32.04017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (864, 857, '竹溪县', '竹溪县', 3, '420324', '109.715322', '32.318257');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (865, 857, '郧西县', '郧西县', 3, '420322', '110.426005', '32.993095');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (866, 842, '天门市', '天门市', 2, '429006', '113.166545', '30.663706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (867, 866, '胡市镇', '胡市镇', 3, '429006', '113.422', '30.802');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (868, 866, '黄潭镇', '黄潭镇', 3, '429006', '113.039', '30.6922');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (869, 866, '多祥镇', '多祥镇', 3, '429006', '113.358', '30.4234');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (870, 866, '沉湖管委会', '沉湖管委会', 3, '429006', '113.399', '30.4588');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (871, 866, '干驿镇', '干驿镇', 3, '429006', '113.451', '30.503');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (872, 866, '马湾镇', '马湾镇', 3, '429006', '113.312', '30.5993');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (873, 866, '横林镇', '横林镇', 3, '429006', '113.215', '30.5643');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (874, 866, '蒋湖农场', '蒋湖农场', 3, '429006', '112.802', '30.6364');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (875, 866, '小板镇', '小板镇', 3, '429006', '113.264', '30.6151');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (876, 866, '岳口镇', '岳口镇', 3, '429006', '113.105', '30.5868');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (877, 866, '多宝镇', '多宝镇', 3, '429006', '112.614', '30.7034');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (878, 866, '蒋场镇', '蒋场镇', 3, '429006', '112.927', '30.646');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (879, 866, '石家河镇', '石家河镇', 3, '429006', '113.076', '30.8211');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (880, 866, '彭市镇', '彭市镇', 3, '429006', '113.157', '30.4315');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (881, 866, '九真镇', '九真镇', 3, '429006', '113.206', '30.8245');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (882, 866, '佛子山镇', '佛子山镇', 3, '429006', '113.068', '30.6892');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (883, 866, '竟陵街道', '竟陵街道', 3, '429006', '113.183', '30.7066');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (884, 866, '候口街道', '候口街道', 3, '429006', '113.134', '30.652');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (885, 866, '麻洋镇', '麻洋镇', 3, '429006', '113.309', '30.5249');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (886, 866, '杨林街道', '杨林街道', 3, '429006', '113.265', '30.6856');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (887, 866, '汪场镇', '汪场镇', 3, '429006', '112.979', '30.638');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (888, 866, '皂市镇', '皂市镇', 3, '429006', '113.223', '30.7957');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (889, 866, '白茅湖农场', '白茅湖农场', 3, '429006', '113.063', '30.5868');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (890, 866, '张港镇', '张港镇', 3, '429006', '112.801', '30.5529');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (891, 866, '拖市镇', '拖市镇', 3, '429006', '112.856', '30.7135');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (892, 866, '渔薪镇', '渔薪镇', 3, '429006', '112.879', '30.6744');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (893, 866, '净潭乡', '净潭乡', 3, '429006', '113.451', '30.6464');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (894, 866, '卢市镇', '卢市镇', 3, '429006', '113.397', '30.6596');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (895, 842, '武汉市', '武汉市', 2, '420100', '114.304569', '30.593354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (896, 895, '黄陂区', '黄陂区', 3, '420116', '114.375698', '30.882305');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (897, 895, '新洲区', '新洲区', 3, '420117', '114.801284', '30.841304');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (898, 895, '汉南区', '汉南区', 3, '420113', '114.084582', '30.308776');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (899, 895, '蔡甸区', '蔡甸区', 3, '420114', '114.087279', '30.536395');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (900, 895, '江夏区', '江夏区', 3, '420115', '114.320884', '30.37558');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (901, 895, '武昌区', '武昌区', 3, '420106', '114.316464', '30.55418');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (902, 895, '硚口区', '硚口区', 3, '420104', '114.214746', '30.582559');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (903, 895, '东西湖区', '东西湖区', 3, '420112', '114.136295', '30.620079');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (904, 895, '汉阳区', '汉阳区', 3, '420105', '114.21859', '30.554287');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (905, 895, '青山区', '青山区', 3, '420107', '114.385424', '30.639842');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (906, 895, '江汉区', '江汉区', 3, '420103', '114.270763', '30.601129');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (907, 895, '江岸区', '江岸区', 3, '420102', '114.309317', '30.600008');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (908, 895, '洪山区', '洪山区', 3, '420111', '114.342664', '30.500642');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (909, 842, '襄阳市', '襄阳市', 2, '420600', '112.121743', '32.010161');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (910, 909, '谷城县', '谷城县', 3, '420625', '111.653077', '32.26339');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (911, 909, '老河口市', '老河口市', 3, '420682', '111.683861', '32.359068');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (912, 909, '宜城市', '宜城市', 3, '420684', '112.256486', '31.720278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (913, 909, '保康县', '保康县', 3, '420626', '111.261308', '31.87831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (914, 909, '枣阳市', '枣阳市', 3, '420683', '112.772723', '32.128968');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (915, 909, '襄城区', '襄城区', 3, '420602', '112.134025', '32.009932');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (916, 909, '樊城区', '樊城区', 3, '420606', '112.135241', '32.045065');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (917, 909, '南漳县', '南漳县', 3, '420624', '111.838997', '31.774649');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (918, 909, '襄州区', '襄州区', 3, '420607', '112.211365', '32.088651');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (919, 842, '孝感市', '孝感市', 2, '420900', '113.956962', '30.918311');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (920, 919, '云梦县', '云梦县', 3, '420923', '113.752958', '31.021736');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (921, 919, '应城市', '应城市', 3, '420981', '113.571864', '30.928592');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (922, 919, '孝南区', '孝南区', 3, '420902', '113.910769', '30.91695');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (923, 919, '汉川市', '汉川市', 3, '420984', '113.838068', '30.673219');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (924, 919, '孝昌县', '孝昌县', 3, '420921', '113.997794', '31.258225');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (925, 919, '安陆市', '安陆市', 3, '420982', '113.688955', '31.25565');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (926, 919, '大悟县', '大悟县', 3, '420922', '114.127122', '31.561179');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (927, 842, '荆门市', '荆门市', 2, '420800', '112.199009', '31.035445');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (928, 927, '钟祥市', '钟祥市', 3, '420881', '112.588032', '31.167933');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (929, 927, '东宝区', '东宝区', 3, '420802', '112.201657', '31.05187');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (930, 927, '掇刀区', '掇刀区', 3, '420804', '112.2079', '30.973397');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (931, 927, '京山市', '京山市', 3, '420882', '113.119561', '31.018414');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (932, 927, '沙洋县', '沙洋县', 3, '420822', '112.588675', '30.709167');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (933, 842, '黄冈市', '黄冈市', 2, '421100', '114.872425', '30.453722');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (934, 933, '麻城市', '麻城市', 3, '421181', '115.008011', '31.172917');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (935, 933, '蕲春县', '蕲春县', 3, '421126', '115.436423', '30.226146');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (936, 933, '黄州区', '黄州区', 3, '421102', '114.880104', '30.434354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (937, 933, '浠水县', '浠水县', 3, '421125', '115.265155', '30.452212');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (938, 933, '红安县', '红安县', 3, '421122', '114.618134', '31.288167');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (939, 933, '英山县', '英山县', 3, '421124', '115.680953', '30.734989');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (940, 933, '武穴市', '武穴市', 3, '421182', '115.595451', '29.869602');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (941, 933, '黄梅县', '黄梅县', 3, '421127', '115.944219', '30.070453');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (942, 933, '罗田县', '罗田县', 3, '421123', '115.399149', '30.783047');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (943, 933, '团风县', '团风县', 3, '421121', '114.872364', '30.643225');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (944, 842, '潜江市', '潜江市', 2, '429005', '112.900279', '30.401954');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (945, 944, '积玉口镇', '积玉口镇', 3, '429005', '112.721', '30.4185');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (946, 944, '泰丰街道', '泰丰街道', 3, '429005', '112.981', '30.4167');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (947, 944, '广华街道', '广华街道', 3, '429005', '112.666', '30.4633');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (948, 944, '潜江经济开发区', '潜江经济开发区', 3, '429005', '112.883', '30.4825');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (949, 944, '周矶管理区', '周矶管理区', 3, '429005', '112.826', '30.4567');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (950, 944, '高场街道', '高场街道', 3, '429005', '112.775', '30.4076');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (951, 944, '周矶街道', '周矶街道', 3, '429005', '112.818', '30.4576');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (952, 944, '总口管理区', '总口管理区', 3, '429005', '112.89', '30.2581');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (953, 944, '运粮湖管理区', '运粮湖管理区', 3, '429005', '112.582', '30.252');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (954, 944, '园林街道', '园林街道', 3, '429005', '112.91', '30.377');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (955, 944, '白鹭湖管理区', '白鹭湖管理区', 3, '429005', '112.716', '30.1788');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (956, 944, '王场镇', '王场镇', 3, '429005', '112.819', '30.4906');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (957, 944, '竹根滩镇', '竹根滩镇', 3, '429005', '112.979', '30.4716');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (958, 944, '渔洋镇', '渔洋镇', 3, '429005', '112.966', '30.2392');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (959, 944, '熊口镇', '熊口镇', 3, '429005', '112.724', '30.3404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (960, 944, '江汉石油管理局', '江汉石油管理局', 3, '429005', '112.793', '30.4635');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (961, 944, '后湖管理区', '后湖管理区', 3, '429005', '112.768', '30.4049');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (962, 944, '熊口管理区', '熊口管理区', 3, '429005', '112.802', '30.195');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (963, 944, '张金镇', '张金镇', 3, '429005', '112.577', '30.2389');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (964, 944, '杨市街道', '杨市街道', 3, '429005', '112.915', '30.3835');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (965, 944, '浩口原种场', '浩口原种场', 3, '429005', '112.643', '30.3784');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (966, 944, '老新镇', '老新镇', 3, '429005', '112.81', '30.2185');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (967, 944, '龙湾镇', '龙湾镇', 3, '429005', '112.69', '30.2848');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (968, 944, '浩口镇', '浩口镇', 3, '429005', '112.65', '30.3695');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (969, 944, '高石碑镇', '高石碑镇', 3, '429005', '112.626', '30.6203');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (970, 842, '恩施土家族苗族自治州', '恩施土家族苗族自治州', 2, '422800', '109.488076', '30.272104');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (971, 970, '恩施市', '恩施市', 3, '422801', '109.479572', '30.295148');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (972, 970, '建始县', '建始县', 3, '422822', '109.722333', '30.602195');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (973, 970, '利川市', '利川市', 3, '422802', '108.936456', '30.290974');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (974, 970, '鹤峰县', '鹤峰县', 3, '422828', '110.034011', '29.890073');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (975, 970, '来凤县', '来凤县', 3, '422827', '109.407697', '29.493474');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (976, 970, '巴东县', '巴东县', 3, '422823', '110.340921', '31.042854');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (977, 970, '宣恩县', '宣恩县', 3, '422825', '109.489918', '29.986856');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (978, 970, '咸丰县', '咸丰县', 3, '422826', '109.140163', '29.665215');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (979, 842, '荆州市', '荆州市', 2, '421000', '112.24143', '30.336282');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (980, 979, '石首市', '石首市', 3, '421081', '112.42538', '29.720944');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (981, 979, '洪湖市', '洪湖市', 3, '421083', '113.475984', '29.827256');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (982, 979, '江陵县', '江陵县', 3, '421024', '112.424581', '30.042227');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (983, 979, '监利市', '监利市', 3, '421088', '112.904634', '29.840229');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (984, 979, '松滋市', '松滋市', 3, '421087', '111.756455', '30.174717');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (985, 979, '沙市区', '沙市区', 3, '421002', '112.251975', '30.326693');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (986, 979, '公安县', '公安县', 3, '421022', '112.229742', '30.058519');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (987, 979, '荆州区', '荆州区', 3, '421003', '112.190282', '30.352984');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (988, 842, '仙桃市', '仙桃市', 2, '429004', '113.442973', '30.328407');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (989, 988, '畜禽良种场', '畜禽良种场', 3, '429004', '113.751', '30.1779');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (990, 988, '豆河镇', '豆河镇', 3, '429004', '113', '30.37');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (991, 988, '工业园区', '工业园区', 3, '429004', '113.413', '30.3233');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (992, 988, '沙湖镇', '沙湖镇', 3, '429004', '113.6', '30.1698');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (993, 988, '通海口镇', '通海口镇', 3, '429004', '113.206', '30.2722');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (994, 988, '长倘口镇', '长倘口镇', 3, '429004', '113.598', '30.3512');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (995, 988, '胡场镇', '胡场镇', 3, '429004', '113.29', '30.4278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (996, 988, '五湖渔场', '五湖渔场', 3, '429004', '113.783', '30.161');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (997, 988, '杨林尾镇', '杨林尾镇', 3, '429004', '113.561', '30.2014');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (998, 988, '干河街道', '干河街道', 3, '429004', '113.451', '30.3772');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (999, 988, '赵西垸林场', '赵西垸林场', 3, '429004', '113.027', '30.285');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1000, 988, '西流河镇', '西流河镇', 3, '429004', '113.761', '30.297');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1001, 988, '彭场镇', '彭场镇', 3, '429004', '113.446', '30.2518');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1002, 988, '九合垸原种场', '九合垸原种场', 3, '429004', '113.006', '30.2473');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1003, 988, '沔城回族镇', '沔城回族镇', 3, '429004', '113.201', '30.1921');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1004, 988, '龙华山街道', '龙华山街道', 3, '429004', '113.46', '30.3649');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1005, 988, '沙湖原种场', '沙湖原种场', 3, '429004', '113.643', '30.1482');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1006, 988, '陈场镇', '陈场镇', 3, '429004', '113.111', '30.2879');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1007, 988, '郑场镇', '郑场镇', 3, '429004', '112.979', '30.4707');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1008, 988, '排湖风景区', '排湖风景区', 3, '429004', '113.223', '30.2987');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1009, 988, '沙嘴街道', '沙嘴街道', 3, '429004', '113.441', '30.3596');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1010, 988, '郭河镇', '郭河镇', 3, '429004', '113.304', '30.3027');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1011, 988, '毛嘴镇', '毛嘴镇', 3, '429004', '113.045', '30.4188');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1012, 988, '张沟镇', '张沟镇', 3, '429004', '113.438', '30.2968');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1013, 988, '三伏潭镇', '三伏潭镇', 3, '429004', '113.207', '30.3395');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1014, 842, '咸宁市', '咸宁市', 2, '421200', '114.322601', '29.84135');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1015, 1014, '嘉鱼县', '嘉鱼县', 3, '421221', '113.939249', '29.970575');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1016, 1014, '咸安区', '咸安区', 3, '421202', '114.299002', '29.852726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1017, 1014, '通山县', '通山县', 3, '421224', '114.482832', '29.606468');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1018, 1014, '赤壁市', '赤壁市', 3, '421281', '113.900385', '29.725122');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1019, 1014, '崇阳县', '崇阳县', 3, '421223', '114.039484', '29.556866');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1020, 1014, '通城县', '通城县', 3, '421222', '113.816811', '29.2454');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1021, 842, '随州市', '随州市', 2, '421300', '113.382324', '31.690275');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1022, 1021, '曾都区', '曾都区', 3, '421303', '113.371052', '31.716423');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1023, 1021, '随县', '随县', 3, '421321', '113.29097', '31.883233');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1024, 1021, '广水市', '广水市', 3, '421381', '113.825977', '31.617015');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1025, 842, '神农架林区', '神农架林区', 2, '429021', '110.675743', '31.744915');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1026, 1025, '下谷坪土家族乡', '下谷坪土家族乡', 3, '429021', '110.113', '31.4153');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1027, 1025, '木鱼镇', '木鱼镇', 3, '429021', '110.312', '31.3933');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1028, 1025, '新华镇', '新华镇', 3, '429021', '110.842', '31.6218');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1029, 1025, '大九湖镇', '大九湖镇', 3, '429021', '110.062', '31.4095');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1030, 1025, '红坪镇', '红坪镇', 3, '429021', '110.196', '31.4718');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1031, 1025, '松柏镇', '松柏镇', 3, '429021', '110.609', '31.7041');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1032, 1025, '宋洛乡', '宋洛乡', 3, '429021', '110.59', '31.7303');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1033, 1025, '阳日镇', '阳日镇', 3, '429021', '110.763', '31.677');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1034, 842, '黄石市', '黄石市', 2, '420200', '115.038999', '30.201082');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1035, 1034, '西塞山区', '西塞山区', 3, '420203', '115.110067', '30.205114');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1036, 1034, '下陆区', '下陆区', 3, '420204', '114.960914', '30.174148');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1037, 1034, '铁山区', '铁山区', 3, '420205', '114.891603', '30.203152');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1038, 1034, '大冶市', '大冶市', 3, '420281', '114.98046', '30.096263');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1039, 1034, '阳新县', '阳新县', 3, '420222', '115.215211', '29.830236');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1040, 1034, '黄石港区', '黄石港区', 3, '420202', '115.065653', '30.223194');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1041, 842, '鄂州市', '鄂州市', 2, '420700', '114.894909', '30.391461');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1042, 1041, '华容区', '华容区', 3, '420703', '114.729945', '30.53515');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1043, 1041, '梁子湖区', '梁子湖区', 3, '420702', '114.684805', '30.100146');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1044, 1041, '鄂城区', '鄂城区', 3, '420704', '114.89157', '30.400535');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1045, 0, '辽宁省', '辽宁省', 1, '210000', '123.435093', '41.836743');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1046, 1045, '葫芦岛市', '葫芦岛市', 2, '211400', '120.836783', '40.710974');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1047, 1046, '建昌县', '建昌县', 3, '211422', '119.836669', '40.824484');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1048, 1046, '兴城市', '兴城市', 3, '211481', '120.756661', '40.60999');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1049, 1046, '龙港区', '龙港区', 3, '211403', '120.894054', '40.735717');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1050, 1046, '绥中县', '绥中县', 3, '211421', '120.34432', '40.325576');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1051, 1046, '连山区', '连山区', 3, '211402', '120.869157', '40.774784');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1052, 1046, '南票区', '南票区', 3, '211404', '120.74971', '41.10721');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1053, 1045, '丹东市', '丹东市', 2, '210600', '124.354419', '40.000646');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1054, 1053, '凤城市', '凤城市', 3, '210682', '124.066873', '40.45218');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1055, 1053, '振安区', '振安区', 3, '210604', '124.470005', '40.20154');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1056, 1053, '东港市', '东港市', 3, '210681', '124.152581', '39.863193');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1057, 1053, '振兴区', '振兴区', 3, '210603', '124.383382', '40.129706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1058, 1053, '宽甸满族自治县', '宽甸满族自治县', 3, '210624', '124.783674', '40.731319');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1059, 1053, '元宝区', '元宝区', 3, '210602', '124.395577', '40.136549');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1060, 1045, '大连市', '大连市', 2, '210200', '121.614786', '38.913962');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1061, 1060, '瓦房店市', '瓦房店市', 3, '210281', '121.979463', '39.62701');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1062, 1060, '庄河市', '庄河市', 3, '210283', '122.965881', '39.680825');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1063, 1060, '普兰店区', '普兰店区', 3, '210214', '121.938299', '39.391565');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1064, 1060, '金州区', '金州区', 3, '210213', '121.782513', '39.050211');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1065, 1060, '旅顺口区', '旅顺口区', 3, '210212', '121.261982', '38.851742');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1066, 1060, '长海县', '长海县', 3, '210224', '122.588487', '39.272779');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1067, 1060, '中山区', '中山区', 3, '210202', '121.644996', '38.918357');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1068, 1060, '甘井子区', '甘井子区', 3, '210211', '121.525469', '38.952998');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1069, 1060, '沙河口区', '沙河口区', 3, '210204', '121.594201', '38.904771');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1070, 1060, '西岗区', '西岗区', 3, '210203', '121.612461', '38.914751');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1071, 1045, '锦州市', '锦州市', 2, '210700', '121.126859', '41.096114');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1072, 1071, '黑山县', '黑山县', 3, '210726', '122.126359', '41.653496');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1073, 1071, '义县', '义县', 3, '210727', '121.239558', '41.533553');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1074, 1071, '凌海市', '凌海市', 3, '210781', '121.35499', '41.160636');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1075, 1071, '太和区', '太和区', 3, '210711', '121.103445', '41.109232');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1076, 1071, '北镇市', '北镇市', 3, '210782', '121.777503', '41.588657');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1077, 1071, '古塔区', '古塔区', 3, '210702', '121.128414', '41.117481');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1078, 1071, '凌河区', '凌河区', 3, '210703', '121.151069', '41.115058');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1079, 1045, '抚顺市', '抚顺市', 2, '210400', '123.957053', '41.881311');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1080, 1079, '新宾满族自治县', '新宾满族自治县', 3, '210422', '125.039994', '41.734031');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1081, 1079, '清原满族自治县', '清原满族自治县', 3, '210423', '124.924028', '42.100804');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1082, 1079, '新抚区', '新抚区', 3, '210402', '123.91293', '41.861922');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1083, 1079, '顺城区', '顺城区', 3, '210411', '123.94504', '41.883375');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1084, 1079, '望花区', '望花区', 3, '210404', '123.784235', '41.853484');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1085, 1079, '东洲区', '东洲区', 3, '210403', '124.038491', '41.853001');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1086, 1079, '抚顺县', '抚顺县', 3, '210421', '123.8999229', '41.73009376');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1087, 1045, '铁岭市', '铁岭市', 2, '211200', '123.726008', '42.223709');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1088, 1087, '开原市', '开原市', 3, '211282', '124.051886', '42.577645');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1089, 1087, '调兵山市', '调兵山市', 3, '211281', '123.567039', '42.468007');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1090, 1087, '清河区', '清河区', 3, '211204', '124.159232', '42.54714');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1091, 1087, '西丰县', '西丰县', 3, '211223', '124.727491', '42.738178');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1092, 1087, '铁岭县', '铁岭县', 3, '211221', '123.728933', '42.223395');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1093, 1087, '银州区', '银州区', 3, '211202', '123.842472', '42.286575');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1094, 1087, '昌图县', '昌图县', 3, '211224', '124.086628', '42.779333');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1095, 1045, '营口市', '营口市', 2, '210800', '122.219148', '40.625027');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1096, 1095, '西市区', '西市区', 3, '210803', '122.206431', '40.666707');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1097, 1095, '大石桥市', '大石桥市', 3, '210882', '122.509006', '40.644482');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1098, 1095, '盖州市', '盖州市', 3, '210881', '122.34845', '40.400259');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1099, 1095, '鲅鱼圈区', '鲅鱼圈区', 3, '210804', '122.121764', '40.226708');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1100, 1095, '站前区', '站前区', 3, '210802', '122.259058', '40.673063');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1101, 1095, '老边区', '老边区', 3, '210811', '122.307956', '40.671279');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1102, 1045, '沈阳市', '沈阳市', 2, '210100', '123.464675', '41.677576');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1103, 1102, '新民市', '新民市', 3, '210181', '122.835964', '41.985757');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1104, 1102, '皇姑区', '皇姑区', 3, '210105', '123.441468', '41.824574');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1105, 1102, '于洪区', '于洪区', 3, '210114', '123.308062', '41.793925');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1106, 1102, '苏家屯区', '苏家屯区', 3, '210111', '123.343937', '41.665153');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1107, 1102, '和平区', '和平区', 3, '210102', '123.420401', '41.789766');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1108, 1102, '康平县', '康平县', 3, '210123', '123.343701', '42.727249');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1109, 1102, '法库县', '法库县', 3, '210124', '123.440294', '42.50108');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1110, 1102, '沈河区', '沈河区', 3, '210103', '123.45884', '41.795688');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1111, 1102, '大东区', '大东区', 3, '210104', '123.469828', '41.805292');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1112, 1102, '铁西区', '铁西区', 3, '210106', '123.334781', '41.821721');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1113, 1102, '辽中区', '辽中区', 3, '210115', '122.766159', '41.517449');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1114, 1102, '浑南区', '浑南区', 3, '210112', '123.449597', '41.714729');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1115, 1102, '沈北新区', '沈北新区', 3, '210113', '123.584209', '41.913071');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1116, 1045, '盘锦市', '盘锦市', 2, '211100', '122.170729', '40.71956');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1117, 1116, '大洼区', '大洼区', 3, '211104', '122.082227', '41.002679');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1118, 1116, '盘山县', '盘山县', 3, '211122', '121.996408', '41.243367');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1119, 1116, '兴隆台区', '兴隆台区', 3, '211103', '122.070685', '41.120261');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1120, 1116, '双台子区', '双台子区', 3, '211102', '122.07597', '41.212401');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1121, 1045, '阜新市', '阜新市', 2, '210900', '121.670052', '42.022028');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1122, 1121, '清河门区', '清河门区', 3, '210905', '121.416105', '41.7831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1123, 1121, '太平区', '太平区', 3, '210904', '121.678637', '42.010689');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1124, 1121, '新邱区', '新邱区', 3, '210903', '121.792067', '42.087549');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1125, 1121, '阜新蒙古族自治县', '阜新蒙古族自治县', 3, '210921', '121.757901', '42.065175');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1126, 1121, '彰武县', '彰武县', 3, '210922', '122.538563', '42.386264');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1127, 1121, '海州区', '海州区', 3, '210902', '121.662594', '42.017794');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1128, 1121, '细河区', '细河区', 3, '210911', '121.680157', '42.025412');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1129, 1045, '本溪市', '本溪市', 2, '210500', '123.684984', '41.486834');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1130, 1129, '桓仁满族自治县', '桓仁满族自治县', 3, '210522', '125.361061', '41.267048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1131, 1129, '溪湖区', '溪湖区', 3, '210503', '123.767817', '41.32931');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1132, 1129, '南芬区', '南芬区', 3, '210505', '123.744822', '41.100273');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1133, 1129, '明山区', '明山区', 3, '210504', '123.861747', '41.343624');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1134, 1129, '平山区', '平山区', 3, '210502', '123.769081', '41.299658');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1135, 1129, '本溪满族自治县', '本溪满族自治县', 3, '210521', '124.119545', '41.301553');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1136, 1045, '鞍山市', '鞍山市', 2, '210300', '122.994183', '41.108239');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1137, 1136, '台安县', '台安县', 3, '210321', '122.436037', '41.412866');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1138, 1136, '岫岩满族自治县', '岫岩满族自治县', 3, '210323', '123.280933', '40.290995');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1139, 1136, '千山区', '千山区', 3, '210311', '122.9447506', '41.0689014');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1140, 1136, '铁东区', '铁东区', 3, '210302', '122.990888', '41.089578');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1141, 1136, '铁西区', '铁西区', 3, '210303', '122.969531', '41.119719');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1142, 1136, '立山区', '立山区', 3, '210304', '123.029091', '41.150401');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1143, 1136, '海城市', '海城市', 3, '210381', '122.685176', '40.882548');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1144, 1045, '辽阳市', '辽阳市', 2, '211000', '123.239669', '41.267396');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1145, 1144, '白塔区', '白塔区', 3, '211002', '123.174347', '41.270397');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1146, 1144, '辽阳县', '辽阳县', 3, '211021', '123.106426', '41.206246');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1147, 1144, '太子河区', '太子河区', 3, '211011', '123.1814403', '41.29502257');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1148, 1144, '文圣区', '文圣区', 3, '211003', '123.231262', '41.282378');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1149, 1144, '灯塔市', '灯塔市', 3, '211081', '123.339398', '41.426537');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1150, 1144, '宏伟区', '宏伟区', 3, '211004', '123.196725', '41.217852');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1151, 1144, '弓长岭区', '弓长岭区', 3, '211005', '123.419567', '41.151787');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1152, 1045, '朝阳市', '朝阳市', 2, '211300', '120.488801', '41.601855');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1153, 1152, '朝阳县', '朝阳县', 3, '211321', '120.390001', '41.497923');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1154, 1152, '北票市', '北票市', 3, '211381', '120.771389', '41.801117');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1155, 1152, '双塔区', '双塔区', 3, '211302', '120.453717', '41.565814');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1156, 1152, '龙城区', '龙城区', 3, '211303', '120.4133759', '41.57674859');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1157, 1152, '建平县', '建平县', 3, '211322', '119.64328', '41.402891');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1158, 1152, '喀喇沁左翼蒙古族自治县', '喀喇沁左翼蒙古族自治县', 3, '211324', '119.741223', '41.12815');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1159, 1152, '凌源市', '凌源市', 3, '211382', '119.401574', '41.245445');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1160, 0, '山东省', '山东省', 1, '370000', '117.020725', '36.670201');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1161, 1160, '烟台市', '烟台市', 2, '370600', '121.447755', '37.464551');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1162, 1161, '芝罘区', '芝罘区', 3, '370602', '121.400303', '37.541312');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1163, 1161, '蓬莱区', '蓬莱区', 3, '370614', '120.829178', '37.79564');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1164, 1161, '莱州市', '莱州市', 3, '370683', '119.942057', '37.178187');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1165, 1161, '海阳市', '海阳市', 3, '370687', '121.173506', '36.688316');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1166, 1161, '龙口市', '龙口市', 3, '370681', '120.47614', '37.645281');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1167, 1161, '莱阳市', '莱阳市', 3, '370682', '120.711555', '36.979757');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1168, 1161, '招远市', '招远市', 3, '370685', '120.433904', '37.354517');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1169, 1161, '莱山区', '莱山区', 3, '370613', '121.444949', '37.511322');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1170, 1161, '福山区', '福山区', 3, '370611', '121.267638', '37.49833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1171, 1161, '栖霞市', '栖霞市', 3, '370686', '120.849595', '37.335993');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1172, 1161, '牟平区', '牟平区', 3, '370612', '121.601015', '37.387454');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1173, 1160, '青岛市', '青岛市', 2, '370200', '120.382665', '36.066938');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1174, 1173, '莱西市', '莱西市', 3, '370285', '120.517581', '36.889167');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1175, 1173, '黄岛区', '黄岛区', 3, '370211', '120.19777', '35.960688');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1176, 1173, '崂山区', '崂山区', 3, '370212', '120.469282', '36.107069');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1177, 1173, '即墨区', '即墨区', 3, '370215', '120.447691', '36.390217');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1178, 1173, '城阳区', '城阳区', 3, '370214', '120.396255', '36.307624');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1179, 1173, '市北区', '市北区', 3, '370203', '120.374675', '36.08765');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1180, 1173, '市南区', '市南区', 3, '370202', '120.412002', '36.075867');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1181, 1173, '李沧区', '李沧区', 3, '370213', '120.432652', '36.145987');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1182, 1173, '平度市', '平度市', 3, '370283', '119.970192', '36.753895');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1183, 1173, '胶州市', '胶州市', 3, '370281', '120.033382', '36.26468');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1184, 1160, '威海市', '威海市', 2, '371000', '122.120519', '37.513315');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1185, 1184, '环翠区', '环翠区', 3, '371002', '122.123115', '37.501735');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1186, 1184, '荣成市', '荣成市', 3, '371082', '122.487036', '37.165698');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1187, 1184, '文登区', '文登区', 3, '371003', '122.08832', '37.196032');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1188, 1184, '乳山市', '乳山市', 3, '371083', '121.539557', '36.920329');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1189, 1160, '淄博市', '淄博市', 2, '370300', '118.054994', '36.813787');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1190, 1189, '高青县', '高青县', 3, '370322', '117.826743', '37.171042');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1191, 1189, '桓台县', '桓台县', 3, '370321', '118.097923', '36.959794');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1192, 1189, '临淄区', '临淄区', 3, '370305', '118.309398', '36.826882');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1193, 1189, '博山区', '博山区', 3, '370304', '117.8627', '36.495014');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1194, 1189, '张店区', '张店区', 3, '370303', '118.017877', '36.807011');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1195, 1189, '沂源县', '沂源县', 3, '370323', '118.170856', '36.185402');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1196, 1189, '周村区', '周村区', 3, '370306', '117.869686', '36.80309');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1197, 1189, '淄川区', '淄川区', 3, '370302', '117.966978', '36.644211');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1198, 1160, '聊城市', '聊城市', 2, '371500', '115.985238', '36.455857');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1199, 1198, '冠县', '冠县', 3, '371525', '115.441684', '36.484011');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1200, 1198, '莘县', '莘县', 3, '371522', '115.669843', '36.233711');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1201, 1198, '东昌府区', '东昌府区', 3, '371502', '116.006399', '36.412737');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1202, 1198, '茌平区', '茌平区', 3, '371503', '116.254865', '36.580814');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1203, 1198, '东阿县', '东阿县', 3, '371524', '116.247655', '36.335198');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1204, 1198, '阳谷县', '阳谷县', 3, '371521', '115.791822', '36.114392');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1205, 1198, '高唐县', '高唐县', 3, '371526', '116.230126', '36.84715');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1206, 1198, '临清市', '临清市', 3, '371581', '115.704982', '36.83828');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1207, 1160, '东营市', '东营市', 2, '370500', '118.674633', '37.433992');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1208, 1207, '利津县', '利津县', 3, '370522', '118.255084', '37.490919');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1209, 1207, '广饶县', '广饶县', 3, '370523', '118.419437', '37.053915');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1210, 1207, '东营区', '东营区', 3, '370502', '118.582182', '37.449035');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1211, 1207, '河口区', '河口区', 3, '370503', '118.525519', '37.886217');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1212, 1207, '垦利区', '垦利区', 3, '370505', '118.575234', '37.573412');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1213, 1160, '滨州市', '滨州市', 2, '371600', '117.970731', '37.382687');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1214, 1213, '滨城区', '滨城区', 3, '371602', '118.019567', '37.431997');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1215, 1213, '沾化区', '沾化区', 3, '371603', '118.098962', '37.698952');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1216, 1213, '博兴县', '博兴县', 3, '371625', '118.110715', '37.154529');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1217, 1213, '邹平市', '邹平市', 3, '371681', '117.74313', '36.863393');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1218, 1213, '无棣县', '无棣县', 3, '371623', '117.625846', '37.770579');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1219, 1213, '阳信县', '阳信县', 3, '371622', '117.603407', '37.632773');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1220, 1213, '惠民县', '惠民县', 3, '371621', '117.593744', '37.47528');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1221, 1160, '枣庄市', '枣庄市', 2, '370400', '117.323759', '34.810858');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1222, 1221, '峄城区', '峄城区', 3, '370404', '117.590738', '34.772931');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1223, 1221, '山亭区', '山亭区', 3, '370406', '117.461866', '35.099638');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1224, 1221, '滕州市', '滕州市', 3, '370481', '117.165881', '35.11412');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1225, 1221, '台儿庄区', '台儿庄区', 3, '370405', '117.734287', '34.563103');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1226, 1221, '市中区', '市中区', 3, '370402', '117.556125', '34.863791');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1227, 1221, '薛城区', '薛城区', 3, '370403', '117.263524', '34.795339');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1228, 1160, '济南市', '济南市', 2, '370100', '117.120128', '36.652069');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1229, 1228, '章丘区', '章丘区', 3, '370114', '117.526228', '36.681258');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1230, 1228, '济阳区', '济阳区', 3, '370115', '117.173722', '36.978299');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1231, 1228, '平阴县', '平阴县', 3, '370124', '116.455865', '36.289813');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1232, 1228, '商河县', '商河县', 3, '370126', '117.157165', '37.309694');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1233, 1228, '长清区', '长清区', 3, '370113', '116.752101', '36.554251');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1234, 1228, '钢城区', '钢城区', 3, '370117', '117.811604', '36.059393');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1235, 1228, '莱芜区', '莱芜区', 3, '370116', '117.675797', '36.214419');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1236, 1228, '天桥区', '天桥区', 3, '370105', '116.987106', '36.678665');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1237, 1228, '历城区', '历城区', 3, '370112', '117.065233', '36.680731');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1238, 1228, '历下区', '历下区', 3, '370102', '117.07632', '36.666395');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1239, 1228, '槐荫区', '槐荫区', 3, '370104', '116.901057', '36.652264');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1240, 1228, '市中区', '市中区', 3, '370103', '116.997472', '36.651121');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1241, 1160, '菏泽市', '菏泽市', 2, '371700', '115.479646', '35.234309');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1242, 1241, '鄄城县', '鄄城县', 3, '371726', '115.544507', '35.534088');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1243, 1241, '定陶区', '定陶区', 3, '371703', '115.583172', '35.105742');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1244, 1241, '成武县', '成武县', 3, '371723', '115.889775', '34.95278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1245, 1241, '郓城县', '郓城县', 3, '371725', '115.938939', '35.575276');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1246, 1241, '巨野县', '巨野县', 3, '371724', '116.062585', '35.388543');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1247, 1241, '曹县', '曹县', 3, '371721', '115.556393', '34.85875');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1248, 1241, '单县', '单县', 3, '371722', '116.106396', '34.779282');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1249, 1241, '牡丹区', '牡丹区', 3, '371702', '115.417021', '35.251911');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1250, 1241, '东明县', '东明县', 3, '371728', '115.107402', '35.275664');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1251, 1160, '泰安市', '泰安市', 2, '370900', '117.086963', '36.201784');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1252, 1251, '新泰市', '新泰市', 3, '370982', '117.768069', '35.90953');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1253, 1251, '东平县', '东平县', 3, '370923', '116.470211', '35.937049');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1254, 1251, '泰山区', '泰山区', 3, '370902', '117.135215', '36.192833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1255, 1251, '岱岳区', '岱岳区', 3, '370911', '117.041651', '36.188088');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1256, 1251, '肥城市', '肥城市', 3, '370983', '116.769098', '36.181975');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1257, 1251, '宁阳县', '宁阳县', 3, '370921', '116.805578', '35.758919');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1258, 1160, '德州市', '德州市', 2, '371400', '116.359244', '37.436492');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1259, 1258, '乐陵市', '乐陵市', 3, '371481', '117.232085', '37.729769');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1260, 1258, '宁津县', '宁津县', 3, '371422', '116.800279', '37.652456');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1261, 1258, '德城区', '德城区', 3, '371402', '116.299558', '37.451051');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1262, 1258, '武城县', '武城县', 3, '371428', '116.069312', '37.213398');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1263, 1258, '庆云县', '庆云县', 3, '371423', '117.384163', '37.774376');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1264, 1258, '齐河县', '齐河县', 3, '371425', '116.762767', '36.784164');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1265, 1258, '陵城区', '陵城区', 3, '371403', '116.576148', '37.336444');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1266, 1258, '平原县', '平原县', 3, '371426', '116.434016', '37.165453');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1267, 1258, '夏津县', '夏津县', 3, '371427', '116.001796', '36.948013');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1268, 1258, '临邑县', '临邑县', 3, '371424', '116.866568', '37.190139');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1269, 1258, '禹城市', '禹城市', 3, '371482', '116.638558', '36.934198');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1270, 1160, '济宁市', '济宁市', 2, '370800', '116.587116', '35.415117');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1271, 1270, '泗水县', '泗水县', 3, '370831', '117.250824', '35.664719');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1272, 1270, '汶上县', '汶上县', 3, '370830', '116.497277', '35.711891');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1273, 1270, '曲阜市', '曲阜市', 3, '370881', '116.986212', '35.581933');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1274, 1270, '邹城市', '邹城市', 3, '370883', '117.007406', '35.402536');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1275, 1270, '嘉祥县', '嘉祥县', 3, '370829', '116.342308', '35.40794');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1276, 1270, '梁山县', '梁山县', 3, '370832', '116.131779', '35.765957');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1277, 1270, '金乡县', '金乡县', 3, '370828', '116.311549', '35.06658');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1278, 1270, '兖州区', '兖州区', 3, '370812', '116.78365', '35.551938');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1279, 1270, '鱼台县', '鱼台县', 3, '370827', '116.650526', '35.012706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1280, 1270, '微山县', '微山县', 3, '370826', '117.129188', '34.806657');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1281, 1270, '任城区', '任城区', 3, '370811', '116.605763', '35.444226');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1282, 1160, '临沂市', '临沂市', 2, '371300', '118.356464', '35.103771');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1283, 1282, '蒙阴县', '蒙阴县', 3, '371328', '117.953367', '35.720128');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1284, 1282, '平邑县', '平邑县', 3, '371326', '117.615201', '35.516849');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1285, 1282, '兰山区', '兰山区', 3, '371302', '118.347332', '35.052797');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1286, 1282, '郯城县', '郯城县', 3, '371322', '118.36727', '34.614077');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1287, 1282, '莒南县', '莒南县', 3, '371327', '118.835166', '35.206252');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1288, 1282, '沂南县', '沂南县', 3, '371321', '118.465259', '35.550078');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1289, 1282, '罗庄区', '罗庄区', 3, '371311', '118.284693', '34.997061');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1290, 1282, '费县', '费县', 3, '371325', '117.9776', '35.265851');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1291, 1282, '兰陵县', '兰陵县', 3, '371324', '118.070912', '34.858235');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1292, 1282, '河东区', '河东区', 3, '371312', '118.403073', '35.088936');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1293, 1282, '临沭县', '临沭县', 3, '371329', '118.650828', '34.920171');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1294, 1282, '沂水县', '沂水县', 3, '371323', '118.628142', '35.790919');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1295, 1160, '日照市', '日照市', 2, '371100', '119.52685', '35.416912');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1296, 1295, '东港区', '东港区', 3, '371102', '119.462287', '35.426037');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1297, 1295, '岚山区', '岚山区', 3, '371103', '119.31881', '35.121985');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1298, 1295, '莒县', '莒县', 3, '371122', '118.869059', '35.59125');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1299, 1295, '五莲县', '五莲县', 3, '371121', '119.213673', '35.760154');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1300, 1160, '潍坊市', '潍坊市', 2, '370700', '119.161721', '36.707668');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1301, 1300, '潍城区', '潍城区', 3, '370702', '119.02491', '36.728077');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1302, 1300, '临朐县', '临朐县', 3, '370724', '118.543274', '36.51246');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1303, 1300, '奎文区', '奎文区', 3, '370705', '119.132288', '36.707459');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1304, 1300, '寿光市', '寿光市', 3, '370783', '118.791062', '36.857133');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1305, 1300, '寒亭区', '寒亭区', 3, '370703', '119.211251', '36.755925');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1306, 1300, '青州市', '青州市', 3, '370781', '118.479637', '36.685178');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1307, 1300, '高密市', '高密市', 3, '370785', '119.755271', '36.382973');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1308, 1300, '昌邑市', '昌邑市', 3, '370786', '119.403185', '36.843256');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1309, 1300, '坊子区', '坊子区', 3, '370704', '119.166343', '36.653671');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1310, 1300, '昌乐县', '昌乐县', 3, '370725', '118.841015', '36.687162');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1311, 1300, '安丘市', '安丘市', 3, '370784', '119.21892', '36.479642');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1312, 1300, '诸城市', '诸城市', 3, '370782', '119.410051', '35.996404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1313, 0, '陕西省', '陕西省', 1, '610000', '108.953939', '34.266611');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1314, 1313, '铜川市', '铜川市', 2, '610200', '108.945116', '34.897133');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1315, 1314, '耀州区', '耀州区', 3, '610204', '108.980095', '34.909685');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1316, 1314, '宜君县', '宜君县', 3, '610222', '109.117063', '35.398624');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1317, 1314, '印台区', '印台区', 3, '610203', '109.099848', '35.11454');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1318, 1314, '王益区', '王益区', 3, '610202', '109.075615', '35.068925');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1319, 1313, '汉中市', '汉中市', 2, '610700', '107.02319', '33.066373');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1320, 1319, '佛坪县', '佛坪县', 3, '610730', '107.990551', '33.524261');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1321, 1319, '西乡县', '西乡县', 3, '610724', '107.766477', '32.983282');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1322, 1319, '略阳县', '略阳县', 3, '610727', '106.15658', '33.327293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1323, 1319, '留坝县', '留坝县', 3, '610729', '106.920781', '33.617637');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1324, 1319, '洋县', '洋县', 3, '610723', '107.545678', '33.222808');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1325, 1319, '宁强县', '宁强县', 3, '610726', '106.257636', '32.830032');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1326, 1319, '勉县', '勉县', 3, '610725', '106.673217', '33.153636');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1327, 1319, '南郑区', '南郑区', 3, '610703', '106.936235', '33.000034');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1328, 1319, '城固县', '城固县', 3, '610722', '107.333787', '33.156937');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1329, 1319, '汉台区', '汉台区', 3, '610702', '107.03201', '33.067523');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1330, 1319, '镇巴县', '镇巴县', 3, '610728', '107.895015', '32.536706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1331, 1313, '榆林市', '榆林市', 2, '610800', '109.734104', '38.28576');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1332, 1331, '府谷县', '府谷县', 3, '610822', '111.016431', '39.015658');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1333, 1331, '榆阳区', '榆阳区', 3, '610802', '109.72054', '38.277078');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1334, 1331, '吴堡县', '吴堡县', 3, '610829', '110.739726', '37.452179');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1335, 1331, '佳县', '佳县', 3, '610828', '110.491345', '38.01951');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1336, 1331, '绥德县', '绥德县', 3, '610826', '110.263226', '37.502984');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1337, 1331, '横山区', '横山区', 3, '610803', '109.294144', '37.962477');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1338, 1331, '米脂县', '米脂县', 3, '610827', '110.183984', '37.755134');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1339, 1331, '神木市', '神木市', 3, '610881', '110.466867', '38.899742');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1340, 1331, '清涧县', '清涧县', 3, '610830', '110.121181', '37.088921');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1341, 1331, '靖边县', '靖边县', 3, '610824', '108.794153', '37.600351');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1342, 1331, '子洲县', '子洲县', 3, '610831', '110.035124', '37.610554');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1343, 1331, '定边县', '定边县', 3, '610825', '107.601048', '37.594976');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1344, 1313, '商洛市', '商洛市', 2, '611000', '109.918646', '33.873358');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1345, 1344, '丹凤县', '丹凤县', 3, '611022', '110.327542', '33.696254');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1346, 1344, '镇安县', '镇安县', 3, '611025', '109.152833', '33.423764');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1347, 1344, '商南县', '商南县', 3, '611023', '110.881741', '33.531071');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1348, 1344, '洛南县', '洛南县', 3, '611021', '110.148526', '34.090815');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1349, 1344, '山阳县', '山阳县', 3, '611024', '109.882289', '33.532172');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1350, 1344, '商州区', '商州区', 3, '611002', '109.941452', '33.862979');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1351, 1344, '柞水县', '柞水县', 3, '611026', '109.114006', '33.686048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1352, 1313, '延安市', '延安市', 2, '610600', '109.49468', '36.650109');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1353, 1352, '子长市', '子长市', 3, '610681', '109.675284', '37.142462');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1354, 1352, '宝塔区', '宝塔区', 3, '610602', '109.489726', '36.585138');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1355, 1352, '甘泉县', '甘泉县', 3, '610627', '109.351046', '36.276645');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1356, 1352, '安塞区', '安塞区', 3, '610603', '109.329236', '36.864571');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1357, 1352, '宜川县', '宜川县', 3, '610630', '110.168963', '36.050178');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1358, 1352, '志丹县', '志丹县', 3, '610625', '108.767816', '36.822232');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1359, 1352, '洛川县', '洛川县', 3, '610629', '109.43249', '35.762626');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1360, 1352, '吴起县', '吴起县', 3, '610626', '108.176501', '36.92746');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1361, 1352, '延川县', '延川县', 3, '610622', '110.193503', '36.878324');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1362, 1352, '延长县', '延长县', 3, '610621', '110.012455', '36.579354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1363, 1352, '富县', '富县', 3, '610628', '109.37884', '35.988111');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1364, 1352, '黄陵县', '黄陵县', 3, '610632', '109.262919', '35.579421');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1365, 1352, '黄龙县', '黄龙县', 3, '610631', '109.84029', '35.584655');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1366, 1313, '西安市', '西安市', 2, '610100', '108.939645', '34.343207');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1367, 1366, '临潼区', '临潼区', 3, '610115', '109.214249', '34.367181');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1368, 1366, '鄠邑区', '鄠邑区', 3, '610118', '108.604772', '34.108707');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1369, 1366, '高陵区', '高陵区', 3, '610117', '109.088269', '34.53502');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1370, 1366, '莲湖区', '莲湖区', 3, '610104', '108.944161', '34.26535');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1371, 1366, '灞桥区', '灞桥区', 3, '610111', '109.064675', '34.273111');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1372, 1366, '阎良区', '阎良区', 3, '610114', '109.226124', '34.662232');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1373, 1366, '未央区', '未央区', 3, '610112', '108.946665', '34.293109');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1374, 1366, '长安区', '长安区', 3, '610116', '108.906944', '34.158668');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1375, 1366, '周至县', '周至县', 3, '610124', '108.222219', '34.163592');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1376, 1366, '蓝田县', '蓝田县', 3, '610122', '109.323473', '34.151256');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1377, 1366, '雁塔区', '雁塔区', 3, '610113', '108.948592', '34.222517');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1378, 1366, '碑林区', '碑林区', 3, '610103', '108.940681', '34.256727');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1379, 1366, '新城区', '新城区', 3, '610102', '108.960707', '34.266601');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1380, 1313, '宝鸡市', '宝鸡市', 2, '610300', '107.237682', '34.362862');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1381, 1380, '麟游县', '麟游县', 3, '610329', '107.793524', '34.677902');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1382, 1380, '陇县', '陇县', 3, '610327', '106.864404', '34.892985');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1383, 1380, '金台区', '金台区', 3, '610303', '107.232733', '34.397071');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1384, 1380, '凤县', '凤县', 3, '610330', '106.515841', '33.910797');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1385, 1380, '千阳县', '千阳县', 3, '610328', '107.132421', '34.642374');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1386, 1380, '渭滨区', '渭滨区', 3, '610302', '107.155344', '34.355068');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1387, 1380, '岐山县', '岐山县', 3, '610323', '107.621397', '34.44373');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1388, 1380, '陈仓区', '陈仓区', 3, '610304', '107.368993', '34.35073');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1389, 1380, '凤翔区', '凤翔区', 3, '610322', '107.401029', '34.522167');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1390, 1380, '太白县', '太白县', 3, '610331', '107.318932', '34.058299');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1391, 1380, '眉县', '眉县', 3, '610326', '107.750039', '34.274774');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1392, 1380, '扶风县', '扶风县', 3, '610324', '107.900157', '34.375636');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1393, 1313, '咸阳市', '咸阳市', 2, '610400', '108.708837', '34.329896');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1394, 1393, '永寿县', '永寿县', 3, '610426', '108.142197', '34.69188');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1395, 1393, '乾县', '乾县', 3, '610424', '108.239316', '34.528262');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1396, 1393, '渭城区', '渭城区', 3, '610404', '108.737062', '34.36202');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1397, 1393, '泾阳县', '泾阳县', 3, '610423', '108.843029', '34.526557');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1398, 1393, '长武县', '长武县', 3, '610428', '107.79906', '35.206273');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1399, 1393, '三原县', '三原县', 3, '610422', '108.940754', '34.617282');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1400, 1393, '淳化县', '淳化县', 3, '610430', '108.580164', '34.798596');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1401, 1393, '秦都区', '秦都区', 3, '610402', '108.706347', '34.329478');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1402, 1393, '礼泉县', '礼泉县', 3, '610425', '108.424682', '34.481875');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1403, 1393, '杨陵区', '杨陵区', 3, '610403', '108.084661', '34.272084');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1404, 1393, '兴平市', '兴平市', 3, '610481', '108.490497', '34.299199');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1405, 1393, '武功县', '武功县', 3, '610431', '108.200275', '34.261026');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1406, 1393, '彬州市', '彬州市', 3, '610482', '108.081892', '35.035702');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1407, 1393, '旬邑县', '旬邑县', 3, '610429', '108.333815', '35.111787');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1408, 1313, '渭南市', '渭南市', 2, '610500', '109.470962', '34.520632');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1409, 1408, '韩城市', '韩城市', 3, '610581', '110.44295', '35.477145');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1410, 1408, '白水县', '白水县', 3, '610527', '109.590501', '35.177497');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1411, 1408, '潼关县', '潼关县', 3, '610522', '110.246105', '34.544294');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1412, 1408, '澄城县', '澄城县', 3, '610525', '109.932439', '35.190256');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1413, 1408, '蒲城县', '蒲城县', 3, '610526', '109.586263', '34.955755');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1414, 1408, '合阳县', '合阳县', 3, '610524', '110.149412', '35.237881');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1415, 1408, '富平县', '富平县', 3, '610528', '109.179903', '34.751599');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1416, 1408, '华阴市', '华阴市', 3, '610582', '110.092286', '34.566552');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1417, 1408, '华州区', '华州区', 3, '610503', '109.775765', '34.497019');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1418, 1408, '大荔县', '大荔县', 3, '610523', '109.941784', '34.797073');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1419, 1408, '临渭区', '临渭区', 3, '610502', '109.510051', '34.498902');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1420, 1313, '安康市', '安康市', 2, '610900', '109.029017', '32.685435');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1421, 1420, '宁陕县', '宁陕县', 3, '610923', '108.314299', '33.310284');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1422, 1420, '石泉县', '石泉县', 3, '610922', '108.248061', '33.03805');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1423, 1420, '汉阴县', '汉阴县', 3, '610921', '108.508792', '32.893057');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1424, 1420, '岚皋县', '岚皋县', 3, '610925', '108.902049', '32.307001');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1425, 1420, '平利县', '平利县', 3, '610926', '109.361919', '32.389061');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1426, 1420, '紫阳县', '紫阳县', 3, '610924', '108.534291', '32.520209');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1427, 1420, '镇坪县', '镇坪县', 3, '610927', '109.526873', '31.883672');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1428, 1420, '旬阳市', '旬阳市', 3, '610928', '109.361783', '32.832213');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1429, 1420, '白河县', '白河县', 3, '610929', '110.112608', '32.80901');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1430, 1420, '汉滨区', '汉滨区', 3, '610902', '109.026928', '32.695436');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1431, 0, '上海市', '上海市', 1, '310000', '121.473667', '31.230525');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1432, 1431, '上海城区', '上海城区', 2, '310100', '121.472644', '31.231706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1433, 1432, '崇明区', '崇明区', 3, '310151', '121.397662', '31.623863');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1434, 1432, '浦东新区', '浦东新区', 3, '310115', '121.544346', '31.221461');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1435, 1432, '金山区', '金山区', 3, '310116', '121.341774', '30.742769');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1436, 1432, '奉贤区', '奉贤区', 3, '310120', '121.473945', '30.918406');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1437, 1432, '嘉定区', '嘉定区', 3, '310114', '121.265276', '31.375566');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1438, 1432, '普陀区', '普陀区', 3, '310107', '121.39547', '31.249618');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1439, 1432, '宝山区', '宝山区', 3, '310113', '121.489431', '31.405242');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1440, 1432, '黄浦区', '黄浦区', 3, '310101', '121.48442', '31.231661');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1441, 1432, '杨浦区', '杨浦区', 3, '310110', '121.525409', '31.259588');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1442, 1432, '长宁区', '长宁区', 3, '310105', '121.424751', '31.220537');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1443, 1432, '松江区', '松江区', 3, '310117', '121.227676', '31.03257');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1444, 1432, '虹口区', '虹口区', 3, '310109', '121.504994', '31.264917');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1445, 1432, '静安区', '静安区', 3, '310106', '121.447348', '31.227718');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1446, 1432, '徐汇区', '徐汇区', 3, '310104', '121.436307', '31.188334');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1447, 1432, '青浦区', '青浦区', 3, '310118', '121.124249', '31.15098');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1448, 1432, '闵行区', '闵行区', 3, '310112', '121.380857', '31.112834');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1449, 0, '贵州省', '贵州省', 1, '520000', '106.705251', '26.600328');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1450, 1449, '铜仁市', '铜仁市', 2, '520600', '109.189528', '27.731555');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1451, 1450, '印江土家族苗族自治县', '印江土家族苗族自治县', 3, '520625', '108.409638', '27.994442');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1452, 1450, '石阡县', '石阡县', 3, '520623', '108.223686', '27.513499');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1453, 1450, '碧江区', '碧江区', 3, '520602', '109.264271', '27.815244');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1454, 1450, '德江县', '德江县', 3, '520626', '108.120773', '28.264028');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1455, 1450, '万山区', '万山区', 3, '520603', '109.153685', '27.671268');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1456, 1450, '玉屏侗族自治县', '玉屏侗族自治县', 3, '520622', '108.906415', '27.235816');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1457, 1450, '思南县', '思南县', 3, '520624', '108.253798', '27.937464');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1458, 1450, '松桃苗族自治县', '松桃苗族自治县', 3, '520628', '109.202877', '28.15427');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1459, 1450, '江口县', '江口县', 3, '520621', '108.843993', '27.704883');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1460, 1450, '沿河土家族自治县', '沿河土家族自治县', 3, '520627', '108.503152', '28.564083');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1461, 1449, '遵义市', '遵义市', 2, '520300', '107.031922', '27.721931');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1462, 1461, '桐梓县', '桐梓县', 3, '520322', '106.824661', '28.132991');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1463, 1461, '绥阳县', '绥阳县', 3, '520323', '107.191326', '27.946049');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1464, 1461, '余庆县', '余庆县', 3, '520329', '107.906043', '27.21513');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1465, 1461, '湄潭县', '湄潭县', 3, '520328', '107.465492', '27.748942');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1466, 1461, '仁怀市', '仁怀市', 3, '520382', '106.401322', '27.791883');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1467, 1461, '播州区', '播州区', 3, '520304', '106.829081', '27.535735');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1468, 1461, '赤水市', '赤水市', 3, '520381', '105.697501', '28.590474');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1469, 1461, '习水县', '习水县', 3, '520330', '106.19715', '28.332923');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1470, 1461, '道真仡佬族苗族自治县', '道真仡佬族苗族自治县', 3, '520325', '107.613076', '28.862548');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1471, 1461, '正安县', '正安县', 3, '520324', '107.454463', '28.553507');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1472, 1461, '务川仡佬族苗族自治县', '务川仡佬族苗族自治县', 3, '520326', '107.899353', '28.562921');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1473, 1461, '凤冈县', '凤冈县', 3, '520327', '107.71646', '27.954424');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1474, 1461, '汇川区', '汇川区', 3, '520303', '106.933727', '27.749716');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1475, 1461, '红花岗区', '红花岗区', 3, '520302', '106.893598', '27.644793');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1476, 1449, '六盘水市', '六盘水市', 2, '520200', '104.830357', '26.592538');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1477, 1476, '钟山区', '钟山区', 3, '520201', '104.843723', '26.574699');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1478, 1476, '六枝特区', '六枝特区', 3, '520203', '105.477199', '26.214356');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1479, 1476, '盘州市', '盘州市', 3, '520281', '104.471554', '25.709878');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1480, 1476, '水城区', '水城区', 3, '520204', '104.957871', '26.547604');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1481, 1449, '黔西南布依族苗族自治州', '黔西南布依族苗族自治州', 2, '522300', '104.906419', '25.087733');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1482, 1481, '兴义市', '兴义市', 3, '522301', '104.895503', '25.09196');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1483, 1481, '兴仁市', '兴仁市', 3, '522302', '105.186132', '25.43509');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1484, 1481, '册亨县', '册亨县', 3, '522327', '105.811592', '24.983663');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1485, 1481, '安龙县', '安龙县', 3, '522328', '105.442702', '25.099014');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1486, 1481, '晴隆县', '晴隆县', 3, '522324', '105.218956', '25.834729');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1487, 1481, '贞丰县', '贞丰县', 3, '522325', '105.64976', '25.38558');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1488, 1481, '望谟县', '望谟县', 3, '522326', '106.094864', '25.174204');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1489, 1481, '普安县', '普安县', 3, '522323', '104.953289', '25.784225');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1490, 1449, '安顺市', '安顺市', 2, '520400', '105.9476', '26.253103');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1491, 1490, '西秀区', '西秀区', 3, '520402', '105.966086', '26.243928');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1492, 1490, '紫云苗族布依族自治县', '紫云苗族布依族自治县', 3, '520425', '106.084441', '25.751047');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1493, 1490, '关岭布依族苗族自治县', '关岭布依族苗族自治县', 3, '520424', '105.538262', '25.953502');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1494, 1490, '镇宁布依族苗族自治县', '镇宁布依族苗族自治县', 3, '520423', '105.770543', '26.057248');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1495, 1490, '平坝区', '平坝区', 3, '520403', '106.255768', '26.405968');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1496, 1490, '普定县', '普定县', 3, '520422', '105.743156', '26.301876');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1497, 1449, '黔南布依族苗族自治州', '黔南布依族苗族自治州', 2, '522700', '107.522303', '26.253136');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1498, 1497, '惠水县', '惠水县', 3, '522731', '106.656993', '26.132045');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1499, 1497, '长顺县', '长顺县', 3, '522729', '106.44057', '26.003187');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1500, 1497, '平塘县', '平塘县', 3, '522727', '107.322635', '25.822395');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1501, 1497, '荔波县', '荔波县', 3, '522722', '107.898809', '25.42379');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1502, 1497, '独山县', '独山县', 3, '522726', '107.557591', '25.865418');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1503, 1497, '罗甸县', '罗甸县', 3, '522728', '106.751724', '25.42616');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1504, 1497, '贵定县', '贵定县', 3, '522723', '107.232208', '26.557205');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1505, 1497, '龙里县', '龙里县', 3, '522730', '106.979177', '26.453546');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1506, 1497, '福泉市', '福泉市', 3, '522702', '107.520371', '26.686773');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1507, 1497, '瓮安县', '瓮安县', 3, '522725', '107.471307', '27.07838');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1508, 1497, '三都水族自治县', '三都水族自治县', 3, '522732', '107.869489', '25.983572');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1509, 1497, '都匀市', '都匀市', 3, '522701', '107.518628', '26.259456');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1510, 1449, '毕节市', '毕节市', 2, '520500', '105.291544', '27.283615');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1511, 1510, '七星关区', '七星关区', 3, '520502', '105.305219', '27.298304');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1512, 1510, '黔西市', '黔西市', 3, '520522', '106.032277', '27.008681');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1513, 1510, '金沙县', '金沙县', 3, '520523', '106.220112', '27.458601');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1514, 1510, '织金县', '织金县', 3, '520524', '105.770249', '26.663649');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1515, 1510, '威宁彝族回族苗族自治县', '威宁彝族回族苗族自治县', 3, '520526', '104.252787', '26.873872');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1516, 1510, '赫章县', '赫章县', 3, '520527', '104.728011', '27.117933');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1517, 1510, '大方县', '大方县', 3, '520521', '105.601963', '27.14443');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1518, 1510, '纳雍县', '纳雍县', 3, '520525', '105.414578', '26.779344');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1519, 1449, '黔东南苗族侗族自治州', '黔东南苗族侗族自治州', 2, '522600', '107.982838', '26.583759');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1520, 1519, '榕江县', '榕江县', 3, '522632', '108.52188', '25.931893');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1521, 1519, '雷山县', '雷山县', 3, '522634', '108.078217', '26.378892');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1522, 1519, '天柱县', '天柱县', 3, '522627', '109.207826', '26.909548');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1523, 1519, '施秉县', '施秉县', 3, '522623', '108.124531', '27.033107');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1524, 1519, '镇远县', '镇远县', 3, '522625', '108.429536', '27.049033');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1525, 1519, '凯里市', '凯里市', 3, '522601', '107.981409', '26.5662');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1526, 1519, '丹寨县', '丹寨县', 3, '522636', '107.789301', '26.19857');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1527, 1519, '黎平县', '黎平县', 3, '522631', '109.125826', '26.213304');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1528, 1519, '从江县', '从江县', 3, '522633', '108.904998', '25.754638');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1529, 1519, '锦屏县', '锦屏县', 3, '522628', '109.200808', '26.675919');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1530, 1519, '台江县', '台江县', 3, '522630', '108.321244', '26.667525');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1531, 1519, '黄平县', '黄平县', 3, '522622', '107.916651', '26.905278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1532, 1519, '岑巩县', '岑巩县', 3, '522626', '108.815855', '27.174124');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1533, 1519, '麻江县', '麻江县', 3, '522635', '107.589455', '26.49129');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1534, 1519, '三穗县', '三穗县', 3, '522624', '108.675265', '26.953359');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1535, 1519, '剑河县', '剑河县', 3, '522629', '108.441501', '26.728274');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1536, 1449, '贵阳市', '贵阳市', 2, '520100', '106.628201', '26.646694');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1537, 1536, '开阳县', '开阳县', 3, '520121', '106.964716', '27.057823');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1538, 1536, '白云区', '白云区', 3, '520113', '106.623069', '26.677932');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1539, 1536, '修文县', '修文县', 3, '520123', '106.591958', '26.836048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1540, 1536, '息烽县', '息烽县', 3, '520122', '106.740407', '27.090479');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1541, 1536, '清镇市', '清镇市', 3, '520181', '106.468686', '26.570435');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1542, 1536, '南明区', '南明区', 3, '520102', '106.714305', '26.568055');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1543, 1536, '花溪区', '花溪区', 3, '520111', '106.67026', '26.409817');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1544, 1536, '观山湖区', '观山湖区', 3, '520115', '106.598978', '26.616134');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1545, 1536, '乌当区', '乌当区', 3, '520112', '106.75069', '26.630911');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1546, 1536, '云岩区', '云岩区', 3, '520103', '106.724394', '26.604604');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1547, 0, '重庆市', '重庆市', 1, '500000', '106.550483', '29.563707');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1548, 1547, '重庆城区', '重庆城区', 2, '500100', '106.504962', '29.533155');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1549, 1548, '璧山区', '璧山区', 3, '500120', '106.204885', '29.577455');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1550, 1548, '潼南区', '潼南区', 3, '500152', '105.840487', '30.191077');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1551, 1548, '铜梁区', '铜梁区', 3, '500151', '106.056265', '29.845248');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1552, 1548, '合川区', '合川区', 3, '500117', '106.27617', '29.971968');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1553, 1548, '长寿区', '长寿区', 3, '500115', '107.080945', '29.857916');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1554, 1548, '大足区', '大足区', 3, '500111', '105.721825', '29.707555');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1555, 1548, '永川区', '永川区', 3, '500118', '105.926951', '29.356384');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1556, 1548, '大渡口区', '大渡口区', 3, '500104', '106.482299', '29.484464');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1557, 1548, '涪陵区', '涪陵区', 3, '500102', '107.246521', '29.752475');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1558, 1548, '荣昌区', '荣昌区', 3, '500153', '105.6118', '29.416892');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1559, 1548, '九龙坡区', '九龙坡区', 3, '500107', '106.510515', '29.502325');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1560, 1548, '万州区', '万州区', 3, '500101', '108.408591', '30.807621');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1561, 1548, '渝中区', '渝中区', 3, '500103', '106.568955', '29.552642');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1562, 1548, '南川区', '南川区', 3, '500119', '107.099147', '29.157879');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1563, 1548, '綦江区', '綦江区', 3, '500110', '106.651213', '29.028117');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1564, 1548, '开州区', '开州区', 3, '500154', '108.39336', '31.160416');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1565, 1548, '梁平区', '梁平区', 3, '500155', '107.769568', '30.654233');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1566, 1548, '江津区', '江津区', 3, '500116', '106.264435', '29.319984');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1567, 1548, '黔江区', '黔江区', 3, '500114', '108.770677', '29.533609');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1568, 1548, '南岸区', '南岸区', 3, '500108', '106.644254', '29.50109');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1569, 1548, '巴南区', '巴南区', 3, '500113', '106.540603', '29.402348');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1570, 1548, '北碚区', '北碚区', 3, '500109', '106.395593', '29.805197');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1571, 1548, '武隆区', '武隆区', 3, '500156', '107.759955', '29.325707');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1572, 1548, '沙坪坝区', '沙坪坝区', 3, '500106', '106.456939', '29.541017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1573, 1548, '江北区', '江北区', 3, '500105', '106.574395', '29.606224');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1574, 1548, '渝北区', '渝北区', 3, '500112', '106.631155', '29.718087');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1575, 1547, '重庆郊县', '重庆郊县', 2, '500200', '108.170255', '29.291965');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1576, 1575, '城口县', '城口县', 3, '500229', '108.664349', '31.947319');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1577, 1575, '巫溪县', '巫溪县', 3, '500238', '109.570038', '31.398619');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1578, 1575, '彭水苗族土家族自治县', '彭水苗族土家族自治县', 3, '500243', '108.165571', '29.293748');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1579, 1575, '奉节县', '奉节县', 3, '500236', '109.401056', '31.018505');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1580, 1575, '秀山土家族苗族自治县', '秀山土家族苗族自治县', 3, '500241', '109.007096', '28.448248');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1581, 1575, '云阳县', '云阳县', 3, '500235', '108.6975', '30.930628');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1582, 1575, '垫江县', '垫江县', 3, '500231', '107.332511', '30.327548');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1583, 1575, '石柱土家族自治县', '石柱土家族自治县', 3, '500240', '108.114251', '29.999066');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1584, 1575, '忠县', '忠县', 3, '500233', '108.038073', '30.299817');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1585, 1575, '丰都县', '丰都县', 3, '500230', '107.731056', '29.863785');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1586, 1575, '酉阳土家族苗族自治县', '酉阳土家族苗族自治县', 3, '500242', '108.76726', '28.841409');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1587, 1575, '巫山县', '巫山县', 3, '500237', '109.878995', '31.07478');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1588, 0, '西藏自治区', '西藏自治区', 1, '540000', '91.117449', '29.648694');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1589, 1588, '拉萨市', '拉萨市', 2, '540100', '91.171924', '29.653491');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1590, 1589, '当雄县', '当雄县', 3, '540122', '91.101186', '30.473134');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1591, 1589, '墨竹工卡县', '墨竹工卡县', 3, '540127', '91.739134', '29.850344');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1592, 1589, '林周县', '林周县', 3, '540121', '91.265287', '29.893545');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1593, 1589, '堆龙德庆区', '堆龙德庆区', 3, '540103', '91.002866', '29.646815');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1594, 1589, '尼木县', '尼木县', 3, '540123', '90.16446', '29.43202');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1595, 1589, '达孜区', '达孜区', 3, '540104', '91.349503', '29.670173');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1596, 1589, '城关区', '城关区', 3, '540102', '91.140368', '29.654813');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1597, 1589, '曲水县', '曲水县', 3, '540124', '90.743355', '29.354293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1598, 1588, '昌都市', '昌都市', 2, '540300', '97.170425', '31.142879');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1599, 1598, '江达县', '江达县', 3, '540321', '98.218336', '31.499176');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1600, 1598, '丁青县', '丁青县', 3, '540324', '95.619868', '31.409024');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1601, 1598, '卡若区', '卡若区', 3, '540302', '97.196021', '31.112087');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1602, 1598, '类乌齐县', '类乌齐县', 3, '540323', '96.600246', '31.211601');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1603, 1598, '洛隆县', '洛隆县', 3, '540329', '95.825169', '30.741988');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1604, 1598, '贡觉县', '贡觉县', 3, '540322', '98.27097', '30.860099');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1605, 1598, '边坝县', '边坝县', 3, '540330', '94.7078', '30.933652');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1606, 1598, '八宿县', '八宿县', 3, '540326', '96.917836', '30.053209');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1607, 1598, '察雅县', '察雅县', 3, '540325', '97.568752', '30.653943');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1608, 1598, '芒康县', '芒康县', 3, '540328', '98.593493', '29.679957');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1609, 1598, '左贡县', '左贡县', 3, '540327', '97.841176', '29.671488');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1610, 1588, '那曲市', '那曲市', 2, '540600', '92.05151', '31.477905');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1611, 1610, '巴青县', '巴青县', 3, '540628', '94.053438', '31.91847');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1612, 1610, '安多县', '安多县', 3, '540624', '91.68195', '32.265016');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1613, 1610, '聂荣县', '聂荣县', 3, '540623', '92.303377', '32.10775');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1614, 1610, '申扎县', '申扎县', 3, '540625', '88.709936', '30.93045');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1615, 1610, '比如县', '比如县', 3, '540622', '93.681302', '31.477914');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1616, 1610, '班戈县', '班戈县', 3, '540627', '90.009822', '31.392157');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1617, 1610, '色尼区', '色尼区', 3, '540602', '92.053498', '31.469645');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1618, 1610, '索县', '索县', 3, '540626', '93.785068', '31.888045');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1619, 1610, '嘉黎县', '嘉黎县', 3, '540621', '93.232347', '30.641543');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1620, 1610, '尼玛县', '尼玛县', 3, '540629', '87.236772', '31.784701');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1621, 1610, '双湖县', '双湖县', 3, '540630', '88.838017', '33.188355');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1622, 1588, '日喀则市', '日喀则市', 2, '540200', '88.880423', '29.266838');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1623, 1622, '仲巴县', '仲巴县', 3, '540232', '84.03153', '29.770279');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1624, 1622, '昂仁县', '昂仁县', 3, '540226', '87.227739', '29.299444');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1625, 1622, '南木林县', '南木林县', 3, '540221', '89.099243', '29.682331');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1626, 1622, '谢通门县', '谢通门县', 3, '540227', '88.255784', '29.425455');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1627, 1622, '桑珠孜区', '桑珠孜区', 3, '540202', '88.898503', '29.247726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1628, 1622, '拉孜县', '拉孜县', 3, '540225', '87.636934', '29.08188');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1629, 1622, '萨嘎县', '萨嘎县', 3, '540236', '85.232941', '29.328818');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1630, 1622, '吉隆县', '吉隆县', 3, '540234', '85.298109', '28.856542');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1631, 1622, '仁布县', '仁布县', 3, '540229', '89.841983', '29.230933');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1632, 1622, '萨迦县', '萨迦县', 3, '540224', '88.021674', '28.899664');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1633, 1622, '白朗县', '白朗县', 3, '540228', '89.261977', '29.107688');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1634, 1622, '定日县', '定日县', 3, '540223', '87.12612', '28.658743');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1635, 1622, '康马县', '康马县', 3, '540230', '89.681663', '28.555627');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1636, 1622, '聂拉木县', '聂拉木县', 3, '540235', '85.982237', '28.155186');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1637, 1622, '江孜县', '江孜县', 3, '540222', '89.605654', '28.91186');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1638, 1622, '岗巴县', '岗巴县', 3, '540237', '88.515318', '28.271189');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1639, 1622, '定结县', '定结县', 3, '540231', '87.765872', '28.364159');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1640, 1622, '亚东县', '亚东县', 3, '540233', '88.907136', '27.486094');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1641, 1588, '山南市', '山南市', 2, '540500', '91.771426', '29.237722');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1642, 1641, '桑日县', '桑日县', 3, '540523', '92.017723', '29.259439');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1643, 1641, '加查县', '加查县', 3, '540528', '92.592701', '29.140355');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1644, 1641, '乃东区', '乃东区', 3, '540502', '91.761538', '29.224904');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1645, 1641, '贡嘎县', '贡嘎县', 3, '540522', '90.978425', '29.290169');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1646, 1641, '扎囊县', '扎囊县', 3, '540521', '91.33725', '29.245113');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1647, 1641, '浪卡子县', '浪卡子县', 3, '540531', '90.400251', '28.96693');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1648, 1641, '琼结县', '琼结县', 3, '540524', '91.684307', '29.024492');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1649, 1641, '曲松县', '曲松县', 3, '540525', '92.203738', '29.062826');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1650, 1641, '措美县', '措美县', 3, '540526', '91.433509', '28.438202');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1651, 1641, '隆子县', '隆子县', 3, '540529', '92.463309', '28.408548');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1652, 1641, '洛扎县', '洛扎县', 3, '540527', '90.859971', '28.385811');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1653, 1641, '错那县', '错那县', 3, '540530', '91.957212', '27.991073');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1654, 1588, '阿里地区', '阿里地区', 2, '542500', '80.105786', '32.500987');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1655, 1654, '札达县', '札达县', 3, '542522', '79.807096', '31.479882');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1656, 1654, '改则县', '改则县', 3, '542526', '84.062612', '32.303148');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1657, 1654, '措勤县', '措勤县', 3, '542527', '85.151881', '31.017272');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1658, 1654, '普兰县', '普兰县', 3, '542521', '81.177116', '30.290467');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1659, 1654, '噶尔县', '噶尔县', 3, '542523', '80.096591', '32.492078');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1660, 1654, '革吉县', '革吉县', 3, '542525', '81.145433', '32.387233');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1661, 1654, '日土县', '日土县', 3, '542524', '79.733552', '33.382017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1662, 1588, '林芝市', '林芝市', 2, '540400', '94.361436', '29.64875');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1663, 1662, '波密县', '波密县', 3, '540424', '95.768439', '29.859751');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1664, 1662, '工布江达县', '工布江达县', 3, '540421', '93.246077', '29.88528');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1665, 1662, '巴宜区', '巴宜区', 3, '540402', '94.361094', '29.636576');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1666, 1662, '墨脱县', '墨脱县', 3, '540423', '95.332108', '29.325425');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1667, 1662, '米林县', '米林县', 3, '540422', '94.213679', '29.213811');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1668, 1662, '朗县', '朗县', 3, '540426', '93.074702', '29.046337');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1669, 1662, '察隅县', '察隅县', 3, '540425', '97.466919', '28.66128');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1670, 0, '安徽省', '安徽省', 1, '340000', '117.330139', '31.734559');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1671, 1670, '池州市', '池州市', 2, '341700', '117.495663', '30.674264');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1672, 1671, '贵池区', '贵池区', 3, '341702', '117.568432', '30.687389');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1673, 1671, '石台县', '石台县', 3, '341722', '117.486211', '30.210218');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1674, 1671, '青阳县', '青阳县', 3, '341723', '117.847366', '30.639006');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1675, 1671, '东至县', '东至县', 3, '341721', '117.027533', '30.111182');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1676, 1670, '铜陵市', '铜陵市', 2, '340700', '117.811298', '30.945214');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1677, 1676, '郊区', '郊区', 3, '340711', '117.767919', '30.821699');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1678, 1676, '铜官区', '铜官区', 3, '340705', '117.856541', '30.936772');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1679, 1676, '义安区', '义安区', 3, '340706', '117.937405', '30.950619');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1680, 1676, '枞阳县', '枞阳县', 3, '340722', '117.250191', '30.705466');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1681, 1670, '马鞍山市', '马鞍山市', 2, '340500', '118.50685', '31.668765');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1682, 1681, '博望区', '博望区', 3, '340506', '118.818276', '31.55117');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1683, 1681, '雨山区', '雨山区', 3, '340504', '118.498675', '31.682374');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1684, 1681, '花山区', '花山区', 3, '340503', '118.511366', '31.700127');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1685, 1681, '和县', '和县', 3, '340523', '118.353668', '31.74248');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1686, 1681, '含山县', '含山县', 3, '340522', '118.101448', '31.735559');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1687, 1681, '当涂县', '当涂县', 3, '340521', '118.497873', '31.570857');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1688, 1670, '安庆市', '安庆市', 2, '340800', '117.115349', '30.531828');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1689, 1688, '岳西县', '岳西县', 3, '340828', '116.359732', '30.849716');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1690, 1688, '潜山市', '潜山市', 3, '340882', '116.581224', '30.631022');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1691, 1688, '宜秀区', '宜秀区', 3, '340811', '116.987469', '30.613189');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1692, 1688, '迎江区', '迎江区', 3, '340802', '117.090878', '30.512768');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1693, 1688, '太湖县', '太湖县', 3, '340825', '116.30881', '30.454198');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1694, 1688, '望江县', '望江县', 3, '340827', '116.70641', '30.128404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1695, 1688, '桐城市', '桐城市', 3, '340881', '116.936588', '31.035476');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1696, 1688, '宿松县', '宿松县', 3, '340826', '116.134485', '30.171663');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1697, 1688, '大观区', '大观区', 3, '340803', '117.013469', '30.553697');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1698, 1688, '怀宁县', '怀宁县', 3, '340822', '116.829612', '30.73484');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1699, 1670, '阜阳市', '阜阳市', 2, '341200', '115.814252', '32.891032');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1700, 1699, '临泉县', '临泉县', 3, '341221', '115.26312', '33.038884');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1701, 1699, '颍泉区', '颍泉区', 3, '341204', '115.807415', '32.925461');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1702, 1699, '颍州区', '颍州区', 3, '341202', '115.806916', '32.883322');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1703, 1699, '太和县', '太和县', 3, '341222', '115.621941', '33.160327');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1704, 1699, '颍东区', '颍东区', 3, '341203', '115.856728', '32.91173');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1705, 1699, '阜南县', '阜南县', 3, '341225', '115.596003', '32.659681');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1706, 1699, '颍上县', '颍上县', 3, '341226', '116.256772', '32.653211');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1707, 1699, '界首市', '界首市', 3, '341282', '115.374688', '33.257799');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1708, 1670, '淮北市', '淮北市', 2, '340600', '116.798362', '33.956264');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1709, 1708, '杜集区', '杜集区', 3, '340602', '116.827949', '33.991412');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1710, 1708, '烈山区', '烈山区', 3, '340604', '116.813221', '33.895407');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1711, 1708, '相山区', '相山区', 3, '340603', '116.795233', '33.959927');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1712, 1708, '濉溪县', '濉溪县', 3, '340621', '116.76616', '33.915612');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1713, 1670, '黄山市', '黄山市', 2, '341000', '118.337643', '29.714886');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1714, 1713, '黄山区', '黄山区', 3, '341003', '118.141632', '30.272991');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1715, 1713, '黟县', '黟县', 3, '341023', '117.938139', '29.92477');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1716, 1713, '祁门县', '祁门县', 3, '341024', '117.717452', '29.854179');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1717, 1713, '徽州区', '徽州区', 3, '341004', '118.336799', '29.827291');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1718, 1713, '屯溪区', '屯溪区', 3, '341002', '118.315012', '29.69655');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1719, 1713, '歙县', '歙县', 3, '341021', '118.415258', '29.861354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1720, 1713, '休宁县', '休宁县', 3, '341022', '118.193533', '29.784532');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1721, 1670, '宣城市', '宣城市', 2, '341800', '118.759127', '30.939278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1722, 1721, '广德市', '广德市', 3, '341882', '119.420799', '30.877608');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1723, 1721, '旌德县', '旌德县', 3, '341825', '118.550043', '30.298287');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1724, 1721, '宣州区', '宣州区', 3, '341802', '118.786098', '30.944356');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1725, 1721, '郎溪县', '郎溪县', 3, '341821', '119.184326', '31.142995');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1726, 1721, '泾县', '泾县', 3, '341823', '118.419552', '30.688793');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1727, 1721, '宁国市', '宁国市', 3, '341881', '118.983085', '30.634032');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1728, 1721, '绩溪县', '绩溪县', 3, '341824', '118.578519', '30.067533');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1729, 1670, '蚌埠市', '蚌埠市', 2, '340300', '117.388566', '32.91682');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1730, 1729, '淮上区', '淮上区', 3, '340311', '117.359352', '32.96557');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1731, 1729, '五河县', '五河县', 3, '340322', '117.881312', '33.126532');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1732, 1729, '禹会区', '禹会区', 3, '340304', '117.34186', '32.929715');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1733, 1729, '怀远县', '怀远县', 3, '340321', '117.205083', '32.971543');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1734, 1729, '龙子湖区', '龙子湖区', 3, '340302', '117.454544', '32.90863');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1735, 1729, '蚌山区', '蚌山区', 3, '340303', '117.373347', '32.916393');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1736, 1729, '固镇县', '固镇县', 3, '340323', '117.316585', '33.318371');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1737, 1670, '滁州市', '滁州市', 2, '341100', '118.333439', '32.255904');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1738, 1737, '明光市', '明光市', 3, '341182', '118.018197', '32.78193');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1739, 1737, '天长市', '天长市', 3, '341181', '119.004838', '32.667409');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1740, 1737, '凤阳县', '凤阳县', 3, '341126', '117.531791', '32.875714');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1741, 1737, '来安县', '来安县', 3, '341122', '118.432581', '32.423072');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1742, 1737, '定远县', '定远县', 3, '341125', '117.698528', '32.530741');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1743, 1737, '琅琊区', '琅琊区', 3, '341102', '118.32115', '32.334475');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1744, 1737, '南谯区', '南谯区', 3, '341103', '118.416715', '32.200084');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1745, 1737, '全椒县', '全椒县', 3, '341124', '118.274149', '32.08593');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1746, 1670, '宿州市', '宿州市', 2, '341300', '116.96419', '33.647726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1747, 1746, '埇桥区', '埇桥区', 3, '341302', '116.977039', '33.640205');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1748, 1746, '泗县', '泗县', 3, '341324', '117.910277', '33.483686');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1749, 1746, '萧县', '萧县', 3, '341322', '116.947289', '34.18884');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1750, 1746, '灵璧县', '灵璧县', 3, '341323', '117.549321', '33.554464');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1751, 1746, '砀山县', '砀山县', 3, '341321', '116.366257', '34.442139');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1752, 1670, '淮南市', '淮南市', 2, '340400', '117.018603', '32.585384');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1753, 1752, '凤台县', '凤台县', 3, '340421', '116.710947', '32.710536');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1754, 1752, '潘集区', '潘集区', 3, '340406', '116.834715', '32.77208');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1755, 1752, '八公山区', '八公山区', 3, '340405', '116.832979', '32.630922');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1756, 1752, '大通区', '大通区', 3, '340402', '117.053314', '32.631519');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1757, 1752, '田家庵区', '田家庵区', 3, '340403', '117.017263', '32.647456');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1758, 1752, '谢家集区', '谢家集区', 3, '340404', '116.860026', '32.599173');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1759, 1752, '寿县', '寿县', 3, '340422', '116.798203', '32.545027');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1760, 1670, '亳州市', '亳州市', 2, '341600', '115.778588', '33.846285');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1761, 1760, '谯城区', '谯城区', 3, '341602', '115.779081', '33.876436');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1762, 1760, '利辛县', '利辛县', 3, '341623', '116.206396', '33.158424');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1763, 1760, '蒙城县', '蒙城县', 3, '341622', '116.56434', '33.265671');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1764, 1760, '涡阳县', '涡阳县', 3, '341621', '116.21665', '33.494134');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1765, 1670, '芜湖市', '芜湖市', 2, '340200', '118.433065', '31.352614');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1766, 1765, '繁昌区', '繁昌区', 3, '340212', '118.198536', '31.101766');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1767, 1765, '无为市', '无为市', 3, '340281', '117.902265', '31.304462');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1768, 1765, '镜湖区', '镜湖区', 3, '340202', '118.385133', '31.34056');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1769, 1765, '鸠江区', '鸠江区', 3, '340207', '118.392337', '31.369752');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1770, 1765, '弋江区', '弋江区', 3, '340209', '118.372664', '31.311421');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1771, 1765, '湾沚区', '湾沚区', 3, '340210', '118.576124', '31.134809');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1772, 1765, '南陵县', '南陵县', 3, '340223', '118.334083', '30.914621');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1773, 1670, '合肥市', '合肥市', 2, '340100', '117.227267', '31.820567');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1774, 1773, '瑶海区', '瑶海区', 3, '340102', '117.30944', '31.858111');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1775, 1773, '巢湖市', '巢湖市', 3, '340181', '117.890236', '31.624464');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1776, 1773, '肥东县', '肥东县', 3, '340122', '117.4779', '31.878601');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1777, 1773, '庐江县', '庐江县', 3, '340124', '117.288165', '31.256978');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1778, 1773, '长丰县', '长丰县', 3, '340121', '117.167632', '32.478347');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1779, 1773, '蜀山区', '蜀山区', 3, '340104', '117.26053', '31.851211');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1780, 1773, '肥西县', '肥西县', 3, '340123', '117.158416', '31.707006');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1781, 1773, '包河区', '包河区', 3, '340111', '117.310133', '31.793801');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1782, 1773, '庐阳区', '庐阳区', 3, '340103', '117.265088', '31.878722');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1783, 1670, '六安市', '六安市', 2, '341500', '116.519729', '31.735892');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1784, 1783, '霍山县', '霍山县', 3, '341525', '116.348274', '31.409668');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1785, 1783, '裕安区', '裕安区', 3, '341503', '116.479505', '31.738789');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1786, 1783, '金安区', '金安区', 3, '341502', '116.539458', '31.75014');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1787, 1783, '金寨县', '金寨县', 3, '341524', '115.934253', '31.727295');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1788, 1783, '霍邱县', '霍邱县', 3, '341522', '116.277966', '32.353362');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1789, 1783, '叶集区', '叶集区', 3, '341504', '115.925271', '31.863693');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1790, 1783, '舒城县', '舒城县', 3, '341523', '116.94863', '31.462036');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1791, 0, '福建省', '福建省', 1, '350000', '119.296194', '26.101082');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1792, 1791, '福州市', '福州市', 2, '350100', '119.296411', '26.074286');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1793, 1792, '罗源县', '罗源县', 3, '350123', '119.549129', '26.490215');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1794, 1792, '连江县', '连江县', 3, '350122', '119.539542', '26.197737');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1795, 1792, '闽清县', '闽清县', 3, '350124', '118.863334', '26.221099');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1796, 1792, '福清市', '福清市', 3, '350181', '119.384388', '25.720081');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1797, 1792, '永泰县', '永泰县', 3, '350125', '118.932746', '25.867198');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1798, 1792, '长乐区', '长乐区', 3, '350112', '119.522952', '25.962925');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1799, 1792, '平潭县', '平潭县', 3, '350128', '119.789893', '25.498767');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1800, 1792, '台江区', '台江区', 3, '350103', '119.31419', '26.052826');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1801, 1792, '马尾区', '马尾区', 3, '350105', '119.439259', '25.998657');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1802, 1792, '仓山区', '仓山区', 3, '350104', '119.27322', '26.047027');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1803, 1792, '闽侯县', '闽侯县', 3, '350121', '119.131362', '26.150428');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1804, 1792, '鼓楼区', '鼓楼区', 3, '350102', '119.304507', '26.082666');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1805, 1792, '晋安区', '晋安区', 3, '350111', '119.328591', '26.081963');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1806, 1791, '漳州市', '漳州市', 2, '350600', '117.647298', '24.515297');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1807, 1806, '华安县', '华安县', 3, '350629', '117.53411', '25.00445');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1808, 1806, '东山县', '东山县', 3, '350626', '117.4295', '23.702034');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1809, 1806, '漳浦县', '漳浦县', 3, '350623', '117.613783', '24.11741');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1810, 1806, '龙海区', '龙海区', 3, '350681', '117.818485', '24.446839');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1811, 1806, '芗城区', '芗城区', 3, '350602', '117.653727', '24.510937');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1812, 1806, '长泰区', '长泰区', 3, '350625', '117.759119', '24.625989');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1813, 1806, '诏安县', '诏安县', 3, '350624', '117.175314', '23.711674');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1814, 1806, '云霄县', '云霄县', 3, '350622', '117.334351', '23.935433');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1815, 1806, '南靖县', '南靖县', 3, '350627', '117.357061', '24.5151');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1816, 1806, '平和县', '平和县', 3, '350628', '117.314798', '24.363831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1817, 1806, '龙文区', '龙文区', 3, '350603', '117.711188', '24.503523');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1818, 1791, '宁德市', '宁德市', 2, '350900', '119.547729', '26.666222');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1819, 1818, '福安市', '福安市', 3, '350981', '119.647871', '27.088274');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1820, 1818, '寿宁县', '寿宁县', 3, '350924', '119.514589', '27.45467');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1821, 1818, '蕉城区', '蕉城区', 3, '350902', '119.526284', '26.660658');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1822, 1818, '福鼎市', '福鼎市', 3, '350982', '120.216559', '27.324796');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1823, 1818, '霞浦县', '霞浦县', 3, '350921', '120.005267', '26.885971');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1824, 1818, '古田县', '古田县', 3, '350922', '118.74603', '26.578134');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1825, 1818, '柘荣县', '柘荣县', 3, '350926', '119.900597', '27.23421');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1826, 1818, '屏南县', '屏南县', 3, '350923', '118.985759', '26.908256');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1827, 1818, '周宁县', '周宁县', 3, '350925', '119.338998', '27.104797');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1828, 1791, '南平市', '南平市', 2, '350700', '118.081325', '27.382829');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1829, 1828, '松溪县', '松溪县', 3, '350724', '118.785429', '27.526028');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1830, 1828, '邵武市', '邵武市', 3, '350781', '117.492778', '27.340672');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1831, 1828, '建阳区', '建阳区', 3, '350703', '118.120392', '27.331996');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1832, 1828, '浦城县', '浦城县', 3, '350722', '118.541079', '27.917804');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1833, 1828, '武夷山市', '武夷山市', 3, '350782', '118.035321', '27.756422');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1834, 1828, '光泽县', '光泽县', 3, '350723', '117.333812', '27.541061');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1835, 1828, '政和县', '政和县', 3, '350725', '118.857703', '27.366122');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1836, 1828, '建瓯市', '建瓯市', 3, '350783', '118.304712', '27.023233');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1837, 1828, '延平区', '延平区', 3, '350702', '118.181806', '26.637503');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1838, 1828, '顺昌县', '顺昌县', 3, '350721', '117.809433', '26.793455');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1839, 1791, '厦门市', '厦门市', 2, '350200', '118.08891', '24.479627');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1840, 1839, '湖里区', '湖里区', 3, '350206', '118.146825', '24.512858');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1841, 1839, '翔安区', '翔安区', 3, '350213', '118.247911', '24.618583');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1842, 1839, '思明区', '思明区', 3, '350203', '118.082745', '24.445676');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1843, 1839, '海沧区', '海沧区', 3, '350205', '118.032883', '24.484688');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1844, 1839, '集美区', '集美区', 3, '350211', '118.097407', '24.575976');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1845, 1839, '同安区', '同安区', 3, '350212', '118.150823', '24.723299');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1846, 1791, '莆田市', '莆田市', 2, '350300', '119.007662', '25.454202');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1847, 1846, '秀屿区', '秀屿区', 3, '350305', '119.105177', '25.318649');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1848, 1846, '荔城区', '荔城区', 3, '350304', '119.014821', '25.432268');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1849, 1846, '涵江区', '涵江区', 3, '350303', '119.116173', '25.459057');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1850, 1846, '仙游县', '仙游县', 3, '350322', '118.689745', '25.373373');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1851, 1846, '城厢区', '城厢区', 3, '350302', '118.994261', '25.419062');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1852, 1791, '泉州市', '泉州市', 2, '350500', '118.675724', '24.874452');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1853, 1852, '永春县', '永春县', 3, '350525', '118.29416', '25.321849');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1854, 1852, '德化县', '德化县', 3, '350526', '118.241104', '25.492102');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1855, 1852, '晋江市', '晋江市', 3, '350582', '118.551659', '24.781635');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1856, 1852, '洛江区', '洛江区', 3, '350504', '118.671168', '24.939319');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1857, 1852, '惠安县', '惠安县', 3, '350521', '118.781037', '25.012449');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1858, 1852, '南安市', '南安市', 3, '350583', '118.385929', '24.960056');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1859, 1852, '石狮市', '石狮市', 3, '350581', '118.647945', '24.731969');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1860, 1852, '金门县', '金门县', 3, '350527', '118.319179', '24.437147');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1861, 1852, '泉港区', '泉港区', 3, '350505', '118.915804', '25.120399');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1862, 1852, '安溪县', '安溪县', 3, '350524', '118.186295', '25.056065');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1863, 1852, '丰泽区', '丰泽区', 3, '350503', '118.613007', '24.890373');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1864, 1852, '鲤城区', '鲤城区', 3, '350502', '118.58652', '24.908133');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1865, 1791, '龙岩市', '龙岩市', 2, '350800', '117.017362', '25.075884');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1866, 1865, '上杭县', '上杭县', 3, '350823', '116.419447', '25.049867');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1867, 1865, '武平县', '武平县', 3, '350824', '116.100216', '25.096139');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1868, 1865, '漳平市', '漳平市', 3, '350881', '117.419823', '25.290481');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1869, 1865, '新罗区', '新罗区', 3, '350802', '117.036816', '25.098942');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1870, 1865, '长汀县', '长汀县', 3, '350821', '116.357581', '25.833531');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1871, 1865, '永定区', '永定区', 3, '350803', '116.732216', '24.724148');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1872, 1865, '连城县', '连城县', 3, '350825', '116.754472', '25.710538');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1873, 1791, '三明市', '三明市', 2, '350400', '117.638919', '26.263455');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1874, 1873, '泰宁县', '泰宁县', 3, '350429', '117.175448', '26.900244');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1875, 1873, '大田县', '大田县', 3, '350425', '117.846828', '25.692535');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1876, 1873, '沙县区', '沙县区', 3, '350427', '117.792551', '26.396843');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1877, 1873, '尤溪县', '尤溪县', 3, '350426', '118.190515', '26.169942');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1878, 1873, '建宁县', '建宁县', 3, '350430', '116.848488', '26.833566');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1879, 1873, '明溪县', '明溪县', 3, '350421', '117.202119', '26.355938');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1880, 1873, '将乐县', '将乐县', 3, '350428', '117.471127', '26.728917');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1881, 1873, '宁化县', '宁化县', 3, '350424', '116.654369', '26.262298');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1882, 1873, '三元区', '三元区', 3, '350403', '117.608013', '26.234032');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1883, 1873, '清流县', '清流县', 3, '350423', '116.816772', '26.177658');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1884, 1873, '永安市', '永安市', 3, '350481', '117.365046', '25.941671');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1885, 0, '湖南省', '湖南省', 1, '430000', '112.982951', '28.116007');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1886, 1885, '衡阳市', '衡阳市', 2, '430400', '112.572016', '26.894216');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1887, 1886, '衡东县', '衡东县', 3, '430424', '112.953113', '27.081086');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1888, 1886, '衡山县', '衡山县', 3, '430423', '112.868361', '27.230225');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1889, 1886, '衡阳县', '衡阳县', 3, '430421', '112.370649', '26.970258');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1890, 1886, '南岳区', '南岳区', 3, '430412', '112.737678', '27.231846');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1891, 1886, '珠晖区', '珠晖区', 3, '430405', '112.620653', '26.894796');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1892, 1886, '祁东县', '祁东县', 3, '430426', '112.090319', '26.799284');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1893, 1886, '石鼓区', '石鼓区', 3, '430407', '112.597937', '26.944257');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1894, 1886, '雁峰区', '雁峰区', 3, '430406', '112.613914', '26.840335');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1895, 1886, '衡南县', '衡南县', 3, '430422', '112.677572', '26.739665');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1896, 1886, '耒阳市', '耒阳市', 3, '430481', '112.859806', '26.422149');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1897, 1886, '蒸湘区', '蒸湘区', 3, '430408', '112.567333', '26.912388');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1898, 1886, '常宁市', '常宁市', 3, '430482', '112.399894', '26.421717');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1899, 1885, '岳阳市', '岳阳市', 2, '430600', '113.128922', '29.35648');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1900, 1899, '华容县', '华容县', 3, '430623', '112.540448', '29.530775');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1901, 1899, '君山区', '君山区', 3, '430611', '113.006434', '29.461017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1902, 1899, '岳阳楼区', '岳阳楼区', 3, '430602', '113.129362', '29.371356');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1903, 1899, '云溪区', '云溪区', 3, '430603', '113.272312', '29.472745');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1904, 1899, '汨罗市', '汨罗市', 3, '430681', '113.067097', '28.806937');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1905, 1899, '湘阴县', '湘阴县', 3, '430624', '112.909248', '28.690123');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1906, 1899, '岳阳县', '岳阳县', 3, '430621', '113.116152', '29.144681');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1907, 1899, '平江县', '平江县', 3, '430626', '113.581296', '28.702018');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1908, 1899, '临湘市', '临湘市', 3, '430682', '113.450461', '29.476687');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1909, 1885, '长沙市', '长沙市', 2, '430100', '112.938882', '28.228304');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1910, 1909, '岳麓区', '岳麓区', 3, '430104', '112.930116', '28.234202');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1911, 1909, '宁乡市', '宁乡市', 3, '430182', '112.551887', '28.277709');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1912, 1909, '望城区', '望城区', 3, '430112', '112.83125', '28.353221');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1913, 1909, '浏阳市', '浏阳市', 3, '430181', '113.64328', '28.163866');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1914, 1909, '开福区', '开福区', 3, '430105', '112.985284', '28.257286');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1915, 1909, '芙蓉区', '芙蓉区', 3, '430102', '113.032605', '28.185351');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1916, 1909, '长沙县', '长沙县', 3, '430121', '113.080555', '28.246821');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1917, 1909, '雨花区', '雨花区', 3, '430111', '113.03853', '28.135795');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1918, 1909, '天心区', '天心区', 3, '430103', '112.98978', '28.114544');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1919, 1885, '湘西土家族苗族自治州', '湘西土家族苗族自治州', 2, '433100', '109.737428', '28.312592');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1920, 1919, '永顺县', '永顺县', 3, '433127', '109.857142', '28.979819');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1921, 1919, '花垣县', '花垣县', 3, '433124', '109.482378', '28.57191');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1922, 1919, '吉首市', '吉首市', 3, '433101', '109.698348', '28.261948');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1923, 1919, '保靖县', '保靖县', 3, '433125', '109.660433', '28.699939');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1924, 1919, '古丈县', '古丈县', 3, '433126', '109.95072', '28.616971');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1925, 1919, '泸溪县', '泸溪县', 3, '433122', '110.219619', '28.216109');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1926, 1919, '龙山县', '龙山县', 3, '433130', '109.443974', '29.457623');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1927, 1919, '凤凰县', '凤凰县', 3, '433123', '109.580815', '27.957441');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1928, 1885, '常德市', '常德市', 2, '430700', '111.69905', '29.031446');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1929, 1928, '澧县', '澧县', 3, '430723', '111.758806', '29.633138');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1930, 1928, '鼎城区', '鼎城区', 3, '430703', '111.679896', '29.017596');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1931, 1928, '津市市', '津市市', 3, '430781', '111.877957', '29.606512');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1932, 1928, '武陵区', '武陵区', 3, '430702', '111.683043', '29.055332');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1933, 1928, '汉寿县', '汉寿县', 3, '430722', '111.970725', '28.906063');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1934, 1928, '桃源县', '桃源县', 3, '430725', '111.488985', '28.90232');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1935, 1928, '安乡县', '安乡县', 3, '430721', '112.171107', '29.41131');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1936, 1928, '临澧县', '临澧县', 3, '430724', '111.647547', '29.440813');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1937, 1928, '石门县', '石门县', 3, '430726', '111.380056', '29.584344');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1938, 1885, '怀化市', '怀化市', 2, '431200', '110.001598', '27.569813');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1939, 1938, '芷江侗族自治县', '芷江侗族自治县', 3, '431228', '109.684696', '27.443429');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1940, 1938, '洪江市', '洪江市', 3, '431281', '109.836475', '27.209385');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1941, 1938, '通道侗族自治县', '通道侗族自治县', 3, '431230', '109.784409', '26.158032');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1942, 1938, '沅陵县', '沅陵县', 3, '431222', '110.393782', '28.452103');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1943, 1938, '辰溪县', '辰溪县', 3, '431223', '110.183159', '28.006235');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1944, 1938, '溆浦县', '溆浦县', 3, '431224', '110.594419', '27.908869');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1945, 1938, '会同县', '会同县', 3, '431225', '109.734724', '26.887156');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1946, 1938, '靖州苗族侗族自治县', '靖州苗族侗族自治县', 3, '431229', '109.696249', '26.575111');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1947, 1938, '麻阳苗族自治县', '麻阳苗族自治县', 3, '431226', '109.817703', '27.857666');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1948, 1938, '新晃侗族自治县', '新晃侗族自治县', 3, '431227', '109.174808', '27.352094');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1949, 1938, '中方县', '中方县', 3, '431221', '109.945436', '27.440554');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1950, 1938, '鹤城区', '鹤城区', 3, '431202', '110.040099', '27.578581');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1951, 1885, '张家界市', '张家界市', 2, '430800', '110.478887', '29.117343');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1952, 1951, '慈利县', '慈利县', 3, '430821', '111.139424', '29.430429');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1953, 1951, '武陵源区', '武陵源区', 3, '430811', '110.550309', '29.345721');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1954, 1951, '永定区', '永定区', 3, '430802', '110.537379', '29.119662');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1955, 1951, '桑植县', '桑植县', 3, '430822', '110.204804', '29.414112');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1956, 1885, '湘潭市', '湘潭市', 2, '430300', '112.945439', '27.83136');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1957, 1956, '岳塘区', '岳塘区', 3, '430304', '112.969444', '27.872013');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1958, 1956, '雨湖区', '雨湖区', 3, '430302', '112.907334', '27.856115');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1959, 1956, '湘潭县', '湘潭县', 3, '430321', '112.950767', '27.779669');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1960, 1956, '韶山市', '韶山市', 3, '430382', '112.525364', '27.914796');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1961, 1956, '湘乡市', '湘乡市', 3, '430381', '112.550268', '27.718655');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1962, 1885, '株洲市', '株洲市', 2, '430200', '113.132783', '27.828862');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1963, 1962, '荷塘区', '荷塘区', 3, '430202', '113.173169', '27.856314');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1964, 1962, '攸县', '攸县', 3, '430223', '113.397152', '27.01516');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1965, 1962, '茶陵县', '茶陵县', 3, '430224', '113.537907', '26.777957');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1966, 1962, '炎陵县', '炎陵县', 3, '430225', '113.772665', '26.489847');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1967, 1962, '天元区', '天元区', 3, '430211', '113.082227', '27.826738');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1968, 1962, '芦淞区', '芦淞区', 3, '430203', '113.153455', '27.785198');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1969, 1962, '渌口区', '渌口区', 3, '430212', '113.143832', '27.699361');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1970, 1962, '石峰区', '石峰区', 3, '430204', '113.117763', '27.875513');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1971, 1962, '醴陵市', '醴陵市', 3, '430281', '113.497119', '27.6457');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1972, 1885, '邵阳市', '邵阳市', 2, '430500', '111.467855', '27.239528');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1973, 1972, '隆回县', '隆回县', 3, '430524', '111.032437', '27.113978');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1974, 1972, '绥宁县', '绥宁县', 3, '430527', '110.155532', '26.582027');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1975, 1972, '双清区', '双清区', 3, '430502', '111.496946', '27.232286');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1976, 1972, '北塔区', '北塔区', 3, '430511', '111.451988', '27.246244');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1977, 1972, '邵阳县', '邵阳县', 3, '430523', '111.273872', '26.990785');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1978, 1972, '大祥区', '大祥区', 3, '430503', '111.438892', '27.222078');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1979, 1972, '城步苗族自治县', '城步苗族自治县', 3, '430529', '110.322239', '26.390598');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1980, 1972, '新邵县', '新邵县', 3, '430522', '111.458656', '27.320917');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1981, 1972, '邵东市', '邵东市', 3, '430582', '111.744268', '27.259812');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1982, 1972, '新宁县', '新宁县', 3, '430528', '110.857294', '26.432913');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1983, 1972, '洞口县', '洞口县', 3, '430525', '110.575962', '27.060274');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1984, 1972, '武冈市', '武冈市', 3, '430581', '110.632286', '26.727414');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1985, 1885, '郴州市', '郴州市', 2, '431000', '113.015517', '25.770117');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1986, 1985, '安仁县', '安仁县', 3, '431028', '113.269703', '26.708569');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1987, 1985, '永兴县', '永兴县', 3, '431023', '113.116587', '26.127155');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1988, 1985, '苏仙区', '苏仙区', 3, '431003', '113.042364', '25.799624');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1989, 1985, '桂东县', '桂东县', 3, '431027', '113.944792', '26.077609');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1990, 1985, '汝城县', '汝城县', 3, '431026', '113.685193', '25.533024');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1991, 1985, '资兴市', '资兴市', 3, '431081', '113.235841', '25.977226');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1992, 1985, '北湖区', '北湖区', 3, '431002', '113.010606', '25.784632');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1993, 1985, '宜章县', '宜章县', 3, '431022', '112.948806', '25.40059');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1994, 1985, '桂阳县', '桂阳县', 3, '431021', '112.733804', '25.75382');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1995, 1985, '临武县', '临武县', 3, '431025', '112.563833', '25.276459');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1996, 1985, '嘉禾县', '嘉禾县', 3, '431024', '112.379216', '25.616025');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1997, 1885, '永州市', '永州市', 2, '431100', '111.613482', '26.419861');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1998, 1997, '东安县', '东安县', 3, '431122', '111.315893', '26.392173');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (1999, 1997, '祁阳市', '祁阳市', 3, '431121', '111.840253', '26.580292');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2000, 1997, '冷水滩区', '冷水滩区', 3, '431103', '111.592373', '26.461313');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2001, 1997, '新田县', '新田县', 3, '431128', '112.203396', '25.903965');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2002, 1997, '零陵区', '零陵区', 3, '431102', '111.629806', '26.222278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2003, 1997, '宁远县', '宁远县', 3, '431126', '111.945925', '25.570817');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2004, 1997, '双牌县', '双牌县', 3, '431123', '111.659967', '25.961909');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2005, 1997, '蓝山县', '蓝山县', 3, '431127', '112.195842', '25.369575');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2006, 1997, '江永县', '江永县', 3, '431125', '111.343543', '25.274461');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2007, 1997, '道县', '道县', 3, '431124', '111.600866', '25.526282');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2008, 1997, '江华瑶族自治县', '江华瑶族自治县', 3, '431129', '111.57951', '25.185257');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2009, 1885, '娄底市', '娄底市', 2, '431300', '111.994468', '27.699838');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2010, 2009, '冷水江市', '冷水江市', 3, '431381', '111.459199', '27.656017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2011, 2009, '新化县', '新化县', 3, '431322', '111.327674', '27.725416');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2012, 2009, '涟源市', '涟源市', 3, '431382', '111.663837', '27.693813');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2013, 2009, '双峰县', '双峰县', 3, '431321', '112.174623', '27.457437');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2014, 2009, '娄星区', '娄星区', 3, '431302', '112.001922', '27.730208');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2015, 1885, '益阳市', '益阳市', 2, '430900', '112.355994', '28.554853');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2016, 2015, '资阳区', '资阳区', 3, '430902', '112.324286', '28.59149');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2017, 2015, '桃江县', '桃江县', 3, '430922', '112.156432', '28.518215');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2018, 2015, '赫山区', '赫山区', 3, '430903', '112.373895', '28.58011');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2019, 2015, '安化县', '安化县', 3, '430923', '111.213296', '28.374223');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2020, 2015, '南县', '南县', 3, '430921', '112.396323', '29.362396');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2021, 2015, '沅江市', '沅江市', 3, '430981', '112.354657', '28.845755');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2022, 0, '海南省', '海南省', 1, '460000', '110.348781', '20.018639');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2023, 2022, '定安县', '定安县', 2, '469021', '110.358001', '19.681215');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2024, 2023, '富文镇', '富文镇', 3, '469021', '110.232', '19.521');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2025, 2023, '新竹镇', '新竹镇', 3, '469021', '110.159', '19.5843');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2026, 2023, '黄竹镇', '黄竹镇', 3, '469021', '110.528', '19.4887');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2027, 2023, '国营中瑞农场', '国营中瑞农场', 3, '469021', '110.244', '19.3008');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2028, 2023, '岭口镇', '岭口镇', 3, '469021', '110.276', '19.3601');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2029, 2023, '雷鸣镇', '雷鸣镇', 3, '469021', '110.273', '19.5137');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2030, 2023, '定城镇', '定城镇', 3, '469021', '110.317', '19.7017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2031, 2023, '国营南海农场', '国营南海农场', 3, '469021', '110.469', '19.4432');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2032, 2023, '翰林镇', '翰林镇', 3, '469021', '110.24', '19.2982');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2033, 2023, '龙门镇', '龙门镇', 3, '469021', '110.298', '19.4997');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2034, 2023, '国营金鸡岭农场', '国营金鸡岭农场', 3, '469021', '110.252', '19.5171');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2035, 2023, '龙河镇', '龙河镇', 3, '469021', '110.226', '19.4221');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2036, 2023, '龙湖镇', '龙湖镇', 3, '469021', '110.469', '19.5845');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2037, 2022, '屯昌县', '屯昌县', 2, '469022', '110.101667', '19.351662');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2038, 2037, '国营中建农场', '国营中建农场', 3, '469022', '109.966', '19.2466');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2039, 2037, '屯城镇', '屯城镇', 3, '469022', '110.161', '19.4468');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2040, 2037, '南吕镇', '南吕镇', 3, '469022', '110.05', '19.2222');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2041, 2037, '新兴镇', '新兴镇', 3, '469022', '110.154', '19.5707');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2042, 2037, '坡心镇', '坡心镇', 3, '469022', '110.11', '19.3302');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2043, 2037, '西昌镇', '西昌镇', 3, '469022', '110.024', '19.4428');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2044, 2037, '国营中坤农场', '国营中坤农场', 3, '469022', '109.855', '19.2944');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2045, 2037, '枫木镇', '枫木镇', 3, '469022', '109.994', '19.1901');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2046, 2037, '南坤镇', '南坤镇', 3, '469022', '109.857', '19.2939');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2047, 2037, '乌坡镇', '乌坡镇', 3, '469022', '110.093', '19.1953');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2048, 2022, '临高县', '临高县', 2, '469024', '109.690508', '19.912025');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2049, 2048, '南宝镇', '南宝镇', 3, '469024', '109.638', '19.7516');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2050, 2048, '博厚镇', '博厚镇', 3, '469024', '109.716', '19.893');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2051, 2048, '和舍镇', '和舍镇', 3, '469024', '109.715', '19.6717');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2052, 2048, '调楼镇', '调楼镇', 3, '469024', '109.61', '19.9231');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2053, 2048, '国营加来农场', '国营加来农场', 3, '469024', '109.651', '19.7591');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2054, 2048, '东英镇', '东英镇', 3, '469024', '109.613', '19.9349');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2055, 2048, '波莲镇', '波莲镇', 3, '469024', '109.615', '19.8555');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2056, 2048, '多文镇', '多文镇', 3, '469024', '109.802', '19.7418');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2057, 2048, '新盈镇', '新盈镇', 3, '469024', '109.624', '19.8719');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2058, 2048, '临城镇', '临城镇', 3, '469024', '109.673', '19.8932');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2059, 2048, '皇桐镇', '皇桐镇', 3, '469024', '109.816', '19.8743');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2060, 2048, '国营红华农场', '国营红华农场', 3, '469024', '109.764', '19.8244');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2061, 2022, '东方市', '东方市', 2, '469007', '108.651829', '19.095187');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2062, 2061, '东方华侨农场', '东方华侨农场', 3, '469007', '108.696', '18.9726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2063, 2061, '天安乡', '天安乡', 3, '469007', '108.817', '18.8803');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2064, 2061, '江边乡', '江边乡', 3, '469007', '109.108', '18.8945');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2065, 2061, '东河镇', '东河镇', 3, '469007', '108.991', '19.1321');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2066, 2061, '新龙镇', '新龙镇', 3, '469007', '108.686', '18.9263');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2067, 2061, '国营广坝农场', '国营广坝农场', 3, '469007', '108.732', '18.8589');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2068, 2061, '感城镇', '感城镇', 3, '469007', '108.83', '18.8833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2069, 2061, '三家镇', '三家镇', 3, '469007', '108.798', '19.2498');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2070, 2061, '四更镇', '四更镇', 3, '469007', '108.606', '19.2646');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2071, 2061, '板桥镇', '板桥镇', 3, '469007', '108.87', '18.8744');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2072, 2061, '八所镇', '八所镇', 3, '469007', '108.622', '19.0927');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2073, 2061, '大田镇', '大田镇', 3, '469007', '108.976', '19.1314');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2074, 2022, '昌江黎族自治县', '昌江黎族自治县', 2, '469026', '109.055783', '19.298139');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2075, 2074, '国营霸王岭林场', '国营霸王岭林场', 3, '469026', '109.03', '19.1725');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2076, 2074, '十月田镇', '十月田镇', 3, '469026', '108.989', '19.3818');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2077, 2074, '乌烈镇', '乌烈镇', 3, '469026', '108.81', '19.3525');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2078, 2074, '七叉镇', '七叉镇', 3, '469026', '109.069', '19.1732');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2079, 2074, '海南矿业联合有限公司', '海南矿业联合有限公司', 3, '469026', '108.989', '19.2538');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2080, 2074, '叉河镇', '叉河镇', 3, '469026', '108.989', '19.2536');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2081, 2074, '石碌镇', '石碌镇', 3, '469026', '109.05', '19.2444');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2082, 2074, '海尾镇', '海尾镇', 3, '469026', '108.952', '19.4945');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2083, 2074, '王下乡', '王下乡', 3, '469026', '109.094', '18.9052');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2084, 2074, '国营红林农场', '国营红林农场', 3, '469026', '109.088', '19.2367');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2085, 2074, '昌化镇', '昌化镇', 3, '469026', '108.732', '19.3836');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2086, 2022, '白沙黎族自治县', '白沙黎族自治县', 2, '469025', '109.4429', '19.221641');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2087, 2086, '七坊镇', '七坊镇', 3, '469025', '109.298', '19.3459');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2088, 2086, '金波乡', '金波乡', 3, '469025', '109.157', '19.2577');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2089, 2086, '南开乡', '南开乡', 3, '469025', '109.293', '19.0596');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2090, 2086, '荣邦乡', '荣邦乡', 3, '469025', '109.064', '19.4868');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2091, 2086, '邦溪镇', '邦溪镇', 3, '469025', '109.09', '19.3912');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2092, 2086, '细水乡', '细水乡', 3, '469025', '109.523', '19.2096');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2093, 2086, '元门乡', '元门乡', 3, '469025', '109.455', '19.0981');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2094, 2086, '打安镇', '打安镇', 3, '469025', '109.36', '19.3756');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2095, 2086, '青松乡', '青松乡', 3, '469025', '109.302', '19.0689');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2096, 2086, '国营龙江农场', '国营龙江农场', 3, '469025', '109.178', '19.2369');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2097, 2086, '国营白沙农场', '国营白沙农场', 3, '469025', '109.429', '19.2881');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2098, 2086, '牙叉镇', '牙叉镇', 3, '469025', '109.45', '19.3004');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2099, 2086, '阜龙乡', '阜龙乡', 3, '469025', '109.436', '19.3316');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2100, 2086, '国营邦溪农场', '国营邦溪农场', 3, '469025', '109.18', '19.4104');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2101, 2022, '琼中黎族苗族自治县', '琼中黎族苗族自治县', 2, '469030', '109.838423', '19.03327');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2102, 2101, '吊罗山乡', '吊罗山乡', 3, '469030', '109.917', '18.8198');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2103, 2101, '湾岭镇', '湾岭镇', 3, '469030', '109.9', '19.1334');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2104, 2101, '什运乡', '什运乡', 3, '469030', '109.583', '18.9237');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2105, 2101, '和平镇', '和平镇', 3, '469030', '109.894', '18.899');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2106, 2101, '营根镇', '营根镇', 3, '469030', '109.733', '18.9748');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2107, 2101, '国营乌石农场', '国营乌石农场', 3, '469030', '109.937', '19.0977');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2108, 2101, '国营阳江农场', '国营阳江农场', 3, '469030', '109.823', '19.2127');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2109, 2101, '国营加钗农场', '国营加钗农场', 3, '469030', '109.783', '19.0265');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2110, 2101, '上安乡', '上安乡', 3, '469030', '109.731', '18.9133');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2111, 2101, '国营黎母山林业公司', '国营黎母山林业公司', 3, '469030', '109.703', '19.1542');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2112, 2101, '中平镇', '中平镇', 3, '469030', '110.107', '19.0716');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2113, 2101, '国营长征农场', '国营长征农场', 3, '469030', '109.899', '18.9965');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2114, 2101, '黎母山镇', '黎母山镇', 3, '469030', '109.704', '19.2577');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2115, 2101, '红毛镇', '红毛镇', 3, '469030', '109.734', '19.0657');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2116, 2101, '长征镇', '长征镇', 3, '469030', '109.799', '18.8976');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2117, 2022, '琼海市', '琼海市', 2, '469002', '110.474524', '19.259112');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2118, 2117, '会山镇', '会山镇', 3, '469002', '110.302', '19.0792');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2119, 2117, '嘉积镇', '嘉积镇', 3, '469002', '110.441', '19.3208');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2120, 2117, '国营东太农场', '国营东太农场', 3, '469002', '110.367', '19.1372');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2121, 2117, '国营东升农场', '国营东升农场', 3, '469002', '110.413', '19.284');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2122, 2117, '万泉镇', '万泉镇', 3, '469002', '110.364', '19.2516');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2123, 2117, '大路镇', '大路镇', 3, '469002', '110.424', '19.354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2124, 2117, '彬村山华侨农场', '彬村山华侨农场', 3, '469002', '110.623', '19.3022');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2125, 2117, '国营东红农场', '国营东红农场', 3, '469002', '110.509', '19.364');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2126, 2117, '潭门镇', '潭门镇', 3, '469002', '110.546', '19.2013');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2127, 2117, '龙江镇', '龙江镇', 3, '469002', '110.36', '19.1595');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2128, 2117, '塔洋镇', '塔洋镇', 3, '469002', '110.475', '19.3404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2129, 2117, '阳江镇', '阳江镇', 3, '469002', '110.334', '19.0558');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2130, 2117, '石壁镇', '石壁镇', 3, '469002', '110.168', '19.167');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2131, 2117, '中原镇', '中原镇', 3, '469002', '110.419', '19.1765');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2132, 2117, '博鳌镇', '博鳌镇', 3, '469002', '110.495', '19.1766');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2133, 2117, '长坡镇', '长坡镇', 3, '469002', '110.594', '19.3213');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2134, 2022, '万宁市', '万宁市', 2, '469006', '110.392605', '18.793697');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2135, 2134, '后安镇', '后安镇', 3, '469006', '110.374', '18.9087');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2136, 2134, '国营东和农场', '国营东和农场', 3, '469006', '110.217', '18.7629');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2137, 2134, '万城镇', '万城镇', 3, '469006', '110.414', '18.8276');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2138, 2134, '大茂镇', '大茂镇', 3, '469006', '110.39', '18.8759');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2139, 2134, '礼纪镇', '礼纪镇', 3, '469006', '110.269', '18.7354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2140, 2134, '山根镇', '山根镇', 3, '469006', '110.483', '18.9946');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2141, 2134, '国营东兴农场', '国营东兴农场', 3, '469006', '110.375', '18.894');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2142, 2134, '龙滚镇', '龙滚镇', 3, '469006', '110.495', '18.9855');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2143, 2134, '兴隆华侨农场', '兴隆华侨农场', 3, '469006', '110.106', '18.8195');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2144, 2134, '和乐镇', '和乐镇', 3, '469006', '110.416', '18.9625');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2145, 2134, '三更罗镇', '三更罗镇', 3, '469006', '110.214', '18.9979');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2146, 2134, '地方国营六连林场', '地方国营六连林场', 3, '469006', '110.505', '18.9899');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2147, 2134, '国营新中农场', '国营新中农场', 3, '469006', '110.17', '18.6967');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2148, 2134, '长丰镇', '长丰镇', 3, '469006', '110.321', '18.7876');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2149, 2134, '北大镇', '北大镇', 3, '469006', '110.24', '18.9316');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2150, 2134, '南桥镇', '南桥镇', 3, '469006', '110.196', '18.7201');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2151, 2134, '东澳镇', '东澳镇', 3, '469006', '110.429', '18.6408');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2152, 2022, '三沙市', '三沙市', 2, '460300', '112.338649', '16.831004');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2153, 2152, '南沙区', '南沙区', 3, '460302', '112.896229', '9.548531');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2154, 2152, '西沙区', '西沙区', 3, '460301', '112.346961', '16.834372');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2155, 2022, '乐东黎族自治县', '乐东黎族自治县', 2, '469027', '109.173384', '18.750063');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2156, 2155, '莺歌海镇', '莺歌海镇', 3, '469027', '108.728', '18.4959');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2157, 2155, '国营山荣农场', '国营山荣农场', 3, '469027', '109.223', '18.7507');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2158, 2155, '国营保国农场', '国营保国农场', 3, '469027', '109.245', '18.6612');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2159, 2155, '万冲镇', '万冲镇', 3, '469027', '109.339', '18.7838');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2160, 2155, '利国镇', '利国镇', 3, '469027', '108.965', '18.529');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2161, 2155, '大安镇', '大安镇', 3, '469027', '109.225', '18.5876');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2162, 2155, '国营乐光农场', '国营乐光农场', 3, '469027', '109.192', '18.5331');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2163, 2155, '抱由镇', '抱由镇', 3, '469027', '109.138', '18.8948');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2164, 2155, '九所镇', '九所镇', 3, '469027', '108.927', '18.5276');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2165, 2155, '国营尖峰岭林业公司', '国营尖峰岭林业公司', 3, '469027', '109.027', '18.726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2166, 2155, '尖峰镇', '尖峰镇', 3, '469027', '108.7', '18.7124');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2167, 2155, '佛罗镇', '佛罗镇', 3, '469027', '108.792', '18.5833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2168, 2155, '志仲镇', '志仲镇', 3, '469027', '109.224', '18.5932');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2169, 2155, '黄流镇', '黄流镇', 3, '469027', '108.808', '18.597');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2170, 2155, '国营莺歌海盐场', '国营莺歌海盐场', 3, '469027', '108.729', '18.5523');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2171, 2155, '千家镇', '千家镇', 3, '469027', '109.15', '18.6353');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2172, 2022, '陵水黎族自治县', '陵水黎族自治县', 2, '469028', '110.037553', '18.506045');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2173, 2172, '椰林镇', '椰林镇', 3, '469028', '110.02', '18.4825');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2174, 2172, '新村镇', '新村镇', 3, '469028', '110.026', '18.446');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2175, 2172, '文罗镇', '文罗镇', 3, '469028', '109.914', '18.5734');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2176, 2172, '本号镇', '本号镇', 3, '469028', '109.856', '18.6617');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2177, 2172, '国营南平农场', '国营南平农场', 3, '469028', '109.833', '18.6336');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2178, 2172, '黎安镇', '黎安镇', 3, '469028', '110.146', '18.4342');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2179, 2172, '国营吊罗山林业公司', '国营吊罗山林业公司', 3, '469028', '109.948', '18.6553');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2180, 2172, '光坡镇', '光坡镇', 3, '469028', '110.04', '18.5564');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2181, 2172, '群英乡', '群英乡', 3, '469028', '109.847', '18.5697');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2182, 2172, '提蒙乡', '提蒙乡', 3, '469028', '110.013', '18.6404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2183, 2172, '三才镇', '三才镇', 3, '469028', '109.963', '18.4915');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2184, 2172, '隆广镇', '隆广镇', 3, '469028', '109.858', '18.4802');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2185, 2172, '国营岭门农场', '国营岭门农场', 3, '469028', '110.046', '18.6244');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2186, 2172, '英州镇', '英州镇', 3, '469028', '109.876', '18.4739');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2187, 2022, '文昌市', '文昌市', 2, '469005', '110.797473', '19.544234');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2188, 2187, '会文镇', '会文镇', 3, '469005', '110.708', '19.4957');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2189, 2187, '东阁镇', '东阁镇', 3, '469005', '110.799', '19.7566');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2190, 2187, '文教镇', '文教镇', 3, '469005', '110.856', '19.7083');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2191, 2187, '国营罗豆农场', '国营罗豆农场', 3, '469005', '110.624', '19.9713');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2192, 2187, '翁田镇', '翁田镇', 3, '469005', '110.813', '19.9295');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2193, 2187, '国营东路农场', '国营东路农场', 3, '469005', '110.714', '19.8524');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2194, 2187, '龙楼镇', '龙楼镇', 3, '469005', '110.938', '19.6606');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2195, 2187, '锦山镇', '锦山镇', 3, '469005', '110.67', '20.0418');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2196, 2187, '铺前镇', '铺前镇', 3, '469005', '110.675', '20.0377');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2197, 2187, '东郊镇', '东郊镇', 3, '469005', '110.91', '19.6291');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2198, 2187, '冯坡镇', '冯坡镇', 3, '469005', '110.774', '20.0176');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2199, 2187, '国营南阳农场', '国营南阳农场', 3, '469005', '110.556', '19.4727');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2200, 2187, '昌洒镇', '昌洒镇', 3, '469005', '111.26', '19.9626');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2201, 2187, '公坡镇', '公坡镇', 3, '469005', '110.836', '19.8543');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2202, 2187, '抱罗镇', '抱罗镇', 3, '469005', '110.73', '19.889');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2203, 2187, '潭牛镇', '潭牛镇', 3, '469005', '110.623', '19.6785');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2204, 2187, '文城镇', '文城镇', 3, '469005', '110.708', '19.4982');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2205, 2187, '东路镇', '东路镇', 3, '469005', '110.658', '19.8051');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2206, 2187, '重兴镇', '重兴镇', 3, '469005', '110.654', '19.4341');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2207, 2187, '蓬莱镇', '蓬莱镇', 3, '469005', '110.638', '19.5164');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2208, 2022, '儋州市', '儋州市', 2, '460400', '109.580812', '19.520948');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2209, 2208, '光村镇', '光村镇', 3, '460400', '109.467', '19.9035');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2210, 2208, '洋浦经济开发区', '洋浦经济开发区', 3, '460400', '109.162', '19.7962');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2211, 2208, '兰洋镇', '兰洋镇', 3, '460400', '109.682', '19.4833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2212, 2208, '东成镇', '东成镇', 3, '460400', '109.579', '19.7102');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2213, 2208, '和庆镇', '和庆镇', 3, '460400', '109.677', '19.5887');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2214, 2208, '王五镇', '王五镇', 3, '460400', '109.258', '19.6415');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2215, 2208, '国营蓝洋农场', '国营蓝洋农场', 3, '460400', '109.618', '19.5107');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2216, 2208, '华南热作学院', '华南热作学院', 3, '460400', '109.505', '19.573');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2217, 2208, '排浦镇', '排浦镇', 3, '460400', '109.196', '19.65');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2218, 2208, '新州镇', '新州镇', 3, '460400', '109.321', '19.7523');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2219, 2208, '中和镇', '中和镇', 3, '460400', '109.351', '19.7747');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2220, 2208, '海头镇', '海头镇', 3, '460400', '108.948', '19.4939');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2221, 2208, '木棠镇', '木棠镇', 3, '460400', '109.33', '19.8594');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2222, 2208, '雅星镇', '雅星镇', 3, '460400', '109.156', '19.4695');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2223, 2208, '国营西联农场', '国营西联农场', 3, '460400', '109.537', '19.6556');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2224, 2208, '南丰镇', '南丰镇', 3, '460400', '109.532', '19.4981');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2225, 2208, '国营西培农场', '国营西培农场', 3, '460400', '109.31', '19.4969');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2226, 2208, '国营八一农场', '国营八一农场', 3, '460400', '109.23', '19.3915');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2227, 2208, '白马井镇', '白马井镇', 3, '460400', '109.268', '19.7046');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2228, 2208, '那大镇', '那大镇', 3, '460400', '109.573', '19.5907');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2229, 2208, '三都镇', '三都镇', 3, '460400', '109.176', '19.7946');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2230, 2208, '大成镇', '大成镇', 3, '460400', '109.345', '19.4765');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2231, 2208, '峨蔓镇', '峨蔓镇', 3, '460400', '109.333', '19.8438');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2232, 2022, '澄迈县', '澄迈县', 2, '469023', '110.007497', '19.738885');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2233, 2232, '福山镇', '福山镇', 3, '469023', '109.919', '19.7325');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2234, 2232, '永发镇', '永发镇', 3, '469023', '110.186', '19.6424');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2235, 2232, '桥头镇', '桥头镇', 3, '469023', '109.931', '19.9171');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2236, 2232, '中兴镇', '中兴镇', 3, '469023', '109.938', '19.5697');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2237, 2232, '金江镇', '金江镇', 3, '469023', '109.987', '19.7817');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2238, 2232, '老城镇', '老城镇', 3, '469023', '110.159', '19.9529');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2239, 2232, '文儒镇', '文儒镇', 3, '469023', '110.121', '19.6454');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2240, 2232, '瑞溪镇', '瑞溪镇', 3, '469023', '110.087', '19.7731');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2241, 2232, '国营红岗农场', '国营红岗农场', 3, '469023', '110.038', '19.5642');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2242, 2232, '国营红光农场', '国营红光农场', 3, '469023', '109.957', '19.8731');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2243, 2232, '大丰镇', '大丰镇', 3, '469023', '109.989', '19.904');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2244, 2232, '加乐镇', '加乐镇', 3, '469023', '110.042', '19.6276');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2245, 2232, '国营昆仑农场', '国营昆仑农场', 3, '469023', '109.802', '19.5127');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2246, 2232, '国营西达农场', '国营西达农场', 3, '469023', '109.862', '19.4343');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2247, 2232, '仁兴镇', '仁兴镇', 3, '469023', '109.916', '19.5062');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2248, 2232, '国营金安农场', '国营金安农场', 3, '469023', '110.123', '19.7367');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2249, 2232, '国营和岭农场', '国营和岭农场', 3, '469023', '109.814', '19.5367');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2250, 2022, '三亚市', '三亚市', 2, '460200', '109.511709', '18.252865');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2251, 2250, '海棠区', '海棠区', 3, '460202', '109.735676', '18.384177');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2252, 2250, '崖州区', '崖州区', 3, '460205', '109.172298', '18.357572');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2253, 2250, '吉阳区', '吉阳区', 3, '460203', '109.578238', '18.28146');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2254, 2250, '天涯区', '天涯区', 3, '460204', '109.452325', '18.298975');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2255, 2022, '海口市', '海口市', 2, '460100', '110.198418', '20.045805');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2256, 2255, '龙华区', '龙华区', 3, '460106', '110.328628', '20.030843');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2257, 2255, '琼山区', '琼山区', 3, '460107', '110.384318', '19.984293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2258, 2255, '美兰区', '美兰区', 3, '460108', '110.366359', '20.028983');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2259, 2255, '秀英区', '秀英区', 3, '460105', '110.293566', '20.007703');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2260, 2022, '保亭黎族苗族自治县', '保亭黎族苗族自治县', 2, '469029', '109.700373', '18.640156');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2261, 2260, '加茂镇', '加茂镇', 3, '469029', '109.719', '18.5033');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2262, 2260, '海南保亭热带作物研究所', '海南保亭热带作物研究所', 3, '469029', '109.709', '18.6282');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2263, 2260, '新政镇', '新政镇', 3, '469029', '109.578', '18.5685');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2264, 2260, '国营金江农场', '国营金江农场', 3, '469029', '109.682', '18.547');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2265, 2260, '保城镇', '保城镇', 3, '469029', '109.747', '18.6854');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2266, 2260, '南林乡', '南林乡', 3, '469029', '109.577', '18.3893');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2267, 2260, '国营新星农场', '国营新星农场', 3, '469029', '109.729', '18.6749');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2268, 2260, '国营三道农场', '国营三道农场', 3, '469029', '109.649', '18.5179');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2269, 2260, '毛感乡', '毛感乡', 3, '469029', '109.503', '18.5563');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2270, 2260, '响水镇', '响水镇', 3, '469029', '109.61', '18.5626');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2271, 2260, '什玲镇', '什玲镇', 3, '469029', '109.74', '18.6941');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2272, 2260, '六弓乡', '六弓乡', 3, '469029', '109.803', '18.5393');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2273, 2260, '三道镇', '三道镇', 3, '469029', '109.66', '18.5251');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2274, 2022, '五指山市', '五指山市', 2, '469001', '109.516784', '18.774827');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2275, 2274, '南圣镇', '南圣镇', 3, '469001', '109.687', '18.8266');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2276, 2274, '毛阳镇', '毛阳镇', 3, '469001', '109.45', '18.8811');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2277, 2274, '水满乡', '水满乡', 3, '469001', '109.601', '18.8995');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2278, 2274, '通什镇', '通什镇', 3, '469001', '109.614', '18.8418');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2279, 2274, '番阳镇', '番阳镇', 3, '469001', '109.334', '18.9132');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2280, 2274, '毛道乡', '毛道乡', 3, '469001', '109.356', '18.7134');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2281, 2274, '畅好乡', '畅好乡', 3, '469001', '109.397', '18.6549');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2282, 2274, '国营畅好农场', '国营畅好农场', 3, '469001', '109.523', '18.7089');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2283, 0, '江苏省', '江苏省', 1, '320000', '118.763563', '32.061377');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2284, 2283, '南通市', '南通市', 2, '320600', '120.894522', '31.981269');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2285, 2284, '海门区', '海门区', 3, '320614', '121.182016', '31.869418');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2286, 2284, '启东市', '启东市', 3, '320681', '121.65523', '31.792831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2287, 2284, '如东县', '如东县', 3, '320623', '121.18495', '32.331584');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2288, 2284, '海安市', '海安市', 3, '320685', '120.46779', '32.532853');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2289, 2284, '崇川区', '崇川区', 3, '320613', '120.857253', '32.010277');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2290, 2284, '如皋市', '如皋市', 3, '320682', '120.574028', '32.371493');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2291, 2284, '通州区', '通州区', 3, '320612', '121.073742', '32.065972');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2292, 2283, '连云港市', '连云港市', 2, '320700', '119.221487', '34.596639');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2293, 2292, '东海县', '东海县', 3, '320722', '118.752869', '34.542194');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2294, 2292, '连云区', '连云区', 3, '320703', '119.338901', '34.760317');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2295, 2292, '灌南县', '灌南县', 3, '320724', '119.315583', '34.087251');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2296, 2292, '赣榆区', '赣榆区', 3, '320707', '119.173173', '34.841336');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2297, 2292, '海州区', '海州区', 3, '320706', '119.163492', '34.572506');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2298, 2292, '灌云县', '灌云县', 3, '320723', '119.239426', '34.284074');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2299, 2283, '淮安市', '淮安市', 2, '320800', '119.113166', '33.551495');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2300, 2299, '淮阴区', '淮阴区', 3, '320804', '119.034895', '33.632588');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2301, 2299, '洪泽区', '洪泽区', 3, '320813', '118.873132', '33.294095');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2302, 2299, '盱眙县', '盱眙县', 3, '320830', '118.544545', '33.011905');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2303, 2299, '金湖县', '金湖县', 3, '320831', '119.020432', '33.024663');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2304, 2299, '涟水县', '涟水县', 3, '320826', '119.260589', '33.781648');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2305, 2299, '淮安区', '淮安区', 3, '320803', '119.141183', '33.50296');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2306, 2299, '清江浦区', '清江浦区', 3, '320812', '119.026662', '33.552579');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2307, 2283, '扬州市', '扬州市', 2, '321000', '119.412834', '32.394404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2308, 2307, '广陵区', '广陵区', 3, '321002', '119.431785', '32.395654');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2309, 2307, '宝应县', '宝应县', 3, '321023', '119.358389', '33.241125');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2310, 2307, '江都区', '江都区', 3, '321012', '119.569684', '32.43571');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2311, 2307, '邗江区', '邗江区', 3, '321003', '119.397935', '32.37741');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2312, 2307, '高邮市', '高邮市', 3, '321084', '119.45892', '32.781606');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2313, 2307, '仪征市', '仪征市', 3, '321081', '119.184468', '32.272833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2314, 2283, '盐城市', '盐城市', 2, '320900', '120.16263', '33.348176');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2315, 2314, '建湖县', '建湖县', 3, '320925', '119.788743', '33.438931');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2316, 2314, '阜宁县', '阜宁县', 3, '320923', '119.802271', '33.758857');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2317, 2314, '射阳县', '射阳县', 3, '320924', '120.326338', '33.766277');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2318, 2314, '滨海县', '滨海县', 3, '320922', '119.820713', '33.990372');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2319, 2314, '盐都区', '盐都区', 3, '320903', '120.153567', '33.338538');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2320, 2314, '东台市', '东台市', 3, '320981', '120.320308', '32.867845');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2321, 2314, '响水县', '响水县', 3, '320921', '119.578332', '34.199172');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2322, 2314, '大丰区', '大丰区', 3, '320904', '120.500761', '33.200047');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2323, 2314, '亭湖区', '亭湖区', 3, '320902', '120.196148', '33.391414');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2324, 2283, '宿迁市', '宿迁市', 2, '321300', '118.275228', '33.963186');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2325, 2324, '泗阳县', '泗阳县', 3, '321323', '118.703636', '33.723576');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2326, 2324, '泗洪县', '泗洪县', 3, '321324', '118.223941', '33.476575');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2327, 2324, '宿城区', '宿城区', 3, '321302', '118.242048', '33.963891');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2328, 2324, '宿豫区', '宿豫区', 3, '321311', '118.330423', '33.94813');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2329, 2324, '沭阳县', '沭阳县', 3, '321322', '118.804321', '34.110642');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2330, 2283, '南京市', '南京市', 2, '320100', '118.796624', '32.059344');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2331, 2330, '雨花台区', '雨花台区', 3, '320114', '118.779087', '31.991291');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2332, 2330, '浦口区', '浦口区', 3, '320111', '118.627165', '32.059796');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2333, 2330, '江宁区', '江宁区', 3, '320115', '118.83951', '31.953195');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2334, 2330, '六合区', '六合区', 3, '320116', '118.822241', '32.323235');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2335, 2330, '高淳区', '高淳区', 3, '320118', '118.892074', '31.328678');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2336, 2330, '溧水区', '溧水区', 3, '320117', '119.028414', '31.651108');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2337, 2330, '建邺区', '建邺区', 3, '320105', '118.731642', '32.003343');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2338, 2330, '秦淮区', '秦淮区', 3, '320104', '118.794792', '32.039065');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2339, 2330, '鼓楼区', '鼓楼区', 3, '320106', '118.769943', '32.066814');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2340, 2330, '玄武区', '玄武区', 3, '320102', '118.797779', '32.048644');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2341, 2330, '栖霞区', '栖霞区', 3, '320113', '118.909117', '32.096423');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2342, 2283, '镇江市', '镇江市', 2, '321100', '119.424441', '32.188141');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2343, 2342, '润州区', '润州区', 3, '321111', '119.411383', '32.195146');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2344, 2342, '扬中市', '扬中市', 3, '321182', '119.796816', '32.236476');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2345, 2342, '京口区', '京口区', 3, '321102', '119.470186', '32.198285');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2346, 2342, '丹徒区', '丹徒区', 3, '321112', '119.433854', '32.132118');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2347, 2342, '丹阳市', '丹阳市', 3, '321181', '119.606071', '32.010035');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2348, 2342, '句容市', '句容市', 3, '321183', '119.168693', '31.945732');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2349, 2283, '泰州市', '泰州市', 2, '321200', '119.922883', '32.456692');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2350, 2349, '海陵区', '海陵区', 3, '321202', '119.923825', '32.49248');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2351, 2349, '靖江市', '靖江市', 3, '321282', '120.277124', '31.98325');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2352, 2349, '高港区', '高港区', 3, '321203', '119.88154', '32.31923');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2353, 2349, '泰兴市', '泰兴市', 3, '321283', '120.051475', '32.173072');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2354, 2349, '姜堰区', '姜堰区', 3, '321204', '120.12807', '32.51029');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2355, 2349, '兴化市', '兴化市', 3, '321281', '119.85255', '32.911952');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2356, 2283, '常州市', '常州市', 2, '320400', '119.974092', '31.811313');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2357, 2356, '溧阳市', '溧阳市', 3, '320481', '119.484164', '31.416967');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2358, 2356, '新北区', '新北区', 3, '320411', '119.960925', '31.86355');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2359, 2356, '钟楼区', '钟楼区', 3, '320404', '119.902081', '31.802608');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2360, 2356, '金坛区', '金坛区', 3, '320413', '119.587503', '31.722384');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2361, 2356, '天宁区', '天宁区', 3, '320402', '119.999439', '31.79232');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2362, 2356, '武进区', '武进区', 3, '320412', '119.942441', '31.701252');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2363, 2283, '无锡市', '无锡市', 2, '320200', '120.311889', '31.491064');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2364, 2363, '新吴区', '新吴区', 3, '320214', '120.364303', '31.49085');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2365, 2363, '锡山区', '锡山区', 3, '320205', '120.357732', '31.589484');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2366, 2363, '宜兴市', '宜兴市', 3, '320282', '119.821873', '31.338429');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2367, 2363, '惠山区', '惠山区', 3, '320206', '120.29843', '31.680282');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2368, 2363, '江阴市', '江阴市', 3, '320281', '120.284794', '31.921642');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2369, 2363, '梁溪区', '梁溪区', 3, '320213', '120.303551', '31.566226');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2370, 2363, '滨湖区', '滨湖区', 3, '320211', '120.284381', '31.527846');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2371, 2283, '苏州市', '苏州市', 2, '320500', '120.585294', '31.299758');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2372, 2371, '太仓市', '太仓市', 3, '320585', '121.130344', '31.458043');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2373, 2371, '吴江区', '吴江区', 3, '320509', '120.645728', '31.138525');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2374, 2371, '相城区', '相城区', 3, '320507', '120.642391', '31.369189');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2375, 2371, '常熟市', '常熟市', 3, '320581', '120.752512', '31.656016');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2376, 2371, '昆山市', '昆山市', 3, '320583', '120.980795', '31.385476');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2377, 2371, '张家港市', '张家港市', 3, '320582', '120.555979', '31.876739');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2378, 2371, '吴中区', '吴中区', 3, '320506', '120.632094', '31.263604');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2379, 2371, '虎丘区', '虎丘区', 3, '320505', '120.434238', '31.329601');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2380, 2371, '姑苏区', '姑苏区', 3, '320508', '120.617367', '31.335648');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2381, 2283, '徐州市', '徐州市', 2, '320300', '117.283752', '34.204224');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2382, 2381, '泉山区', '泉山区', 3, '320311', '117.194405', '34.22655');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2383, 2381, '铜山区', '铜山区', 3, '320312', '117.169698', '34.181162');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2384, 2381, '丰县', '丰县', 3, '320321', '116.658111', '34.697232');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2385, 2381, '鼓楼区', '鼓楼区', 3, '320302', '117.185643', '34.288736');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2386, 2381, '新沂市', '新沂市', 3, '320381', '118.354747', '34.369585');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2387, 2381, '邳州市', '邳州市', 3, '320382', '118.012511', '34.339208');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2388, 2381, '睢宁县', '睢宁县', 3, '320324', '117.941364', '33.913727');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2389, 2381, '贾汪区', '贾汪区', 3, '320305', '117.465137', '34.436492');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2390, 2381, '云龙区', '云龙区', 3, '320303', '117.251515', '34.253638');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2391, 2381, '沛县', '沛县', 3, '320322', '116.936353', '34.760761');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2392, 0, '青海省', '青海省', 1, '630000', '101.780482', '36.622538');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2393, 2392, '海南藏族自治州', '海南藏族自治州', 2, '632500', '100.622647', '36.296399');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2394, 2393, '共和县', '共和县', 3, '632521', '100.619405', '36.284158');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2395, 2393, '贵德县', '贵德县', 3, '632523', '101.43403', '36.039672');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2396, 2393, '同德县', '同德县', 3, '632522', '100.577859', '35.254297');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2397, 2393, '贵南县', '贵南县', 3, '632525', '100.747731', '35.587239');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2398, 2393, '兴海县', '兴海县', 3, '632524', '99.987799', '35.589086');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2399, 2392, '海东市', '海东市', 2, '630200', '102.41064', '36.473448');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2400, 2399, '乐都区', '乐都区', 3, '630202', '102.401614', '36.482242');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2401, 2399, '民和回族土族自治县', '民和回族土族自治县', 3, '630222', '102.830775', '36.320038');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2402, 2399, '化隆回族自治县', '化隆回族自治县', 3, '630224', '102.266007', '36.096124');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2403, 2399, '循化撒拉族自治县', '循化撒拉族自治县', 3, '630225', '102.488958', '35.851079');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2404, 2399, '平安区', '平安区', 3, '630203', '102.108538', '36.500166');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2405, 2399, '互助土族自治县', '互助土族自治县', 3, '630223', '101.958519', '36.844027');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2406, 2392, '海西蒙古族藏族自治州', '海西蒙古族藏族自治州', 2, '632800', '97.33197', '37.348114');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2407, 2406, '天峻县', '天峻县', 3, '632823', '99.02297', '37.301206');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2408, 2406, '都兰县', '都兰县', 3, '632822', '98.095889', '36.302098');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2409, 2406, '格尔木市', '格尔木市', 3, '632801', '94.928293', '36.407272');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2410, 2406, '德令哈市', '德令哈市', 3, '632802', '97.361528', '37.369865');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2411, 2406, '乌兰县', '乌兰县', 3, '632821', '98.47988', '36.941279');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2412, 2406, '海西蒙古族藏族自治州直辖', '海西蒙古族藏族自治州直辖', 3, '632825', '95.357233', '37.853631');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2413, 2406, '茫崖市', '茫崖市', 3, '632803', '90.856372', '38.247537');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2414, 2392, '玉树藏族自治州', '玉树藏族自治州', 2, '632700', '97.006292', '33.006308');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2415, 2414, '治多县', '治多县', 3, '632724', '95.618954', '33.844854');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2416, 2414, '曲麻莱县', '曲麻莱县', 3, '632726', '95.805463', '34.137353');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2417, 2414, '称多县', '称多县', 3, '632723', '97.109487', '33.377504');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2418, 2414, '杂多县', '杂多县', 3, '632722', '95.300723', '32.893185');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2419, 2414, '玉树市', '玉树市', 3, '632701', '97.009184', '32.992934');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2420, 2414, '囊谦县', '囊谦县', 3, '632725', '96.489538', '32.203193');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2421, 2392, '黄南藏族自治州', '黄南藏族自治州', 2, '632300', '102.015397', '35.519317');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2422, 2421, '尖扎县', '尖扎县', 3, '632322', '102.040094', '35.943253');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2423, 2421, '同仁市', '同仁市', 3, '632301', '102.018663', '35.515769');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2424, 2421, '泽库县', '泽库县', 3, '632323', '101.466565', '35.035322');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2425, 2421, '河南蒙古族自治县', '河南蒙古族自治县', 3, '632324', '101.617719', '34.734777');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2426, 2392, '果洛藏族自治州', '果洛藏族自治州', 2, '632600', '100.245161', '34.472179');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2427, 2426, '玛沁县', '玛沁县', 3, '632621', '100.238873', '34.478049');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2428, 2426, '甘德县', '甘德县', 3, '632623', '99.900923', '33.969216');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2429, 2426, '班玛县', '班玛县', 3, '632622', '100.737138', '32.932723');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2430, 2426, '达日县', '达日县', 3, '632624', '99.651863', '33.739293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2431, 2426, '久治县', '久治县', 3, '632625', '101.482831', '33.429471');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2432, 2426, '玛多县', '玛多县', 3, '632626', '98.209217', '34.915645');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2433, 2392, '西宁市', '西宁市', 2, '630100', '101.777795', '36.616621');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2434, 2433, '湟源县', '湟源县', 3, '630123', '101.256464', '36.682426');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2435, 2433, '大通回族土族自治县', '大通回族土族自治县', 3, '630121', '101.685503', '36.926872');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2436, 2433, '城东区', '城东区', 3, '630102', '101.803717', '36.599744');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2437, 2433, '城中区', '城中区', 3, '630103', '101.705357', '36.545545');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2438, 2433, '城西区', '城西区', 3, '630104', '101.765915', '36.628288');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2439, 2433, '城北区', '城北区', 3, '630105', '101.766308', '36.650064');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2440, 2433, '湟中区', '湟中区', 3, '630106', '101.571683', '36.501291');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2441, 2392, '海北藏族自治州', '海北藏族自治州', 2, '632200', '100.900944', '36.954612');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2442, 2441, '海晏县', '海晏县', 3, '632223', '100.994521', '36.896667');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2443, 2441, '刚察县', '刚察县', 3, '632224', '100.145662', '37.325096');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2444, 2441, '门源回族自治县', '门源回族自治县', 3, '632221', '101.611524', '37.388567');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2445, 2441, '祁连县', '祁连县', 3, '632222', '100.253211', '38.177112');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2446, 0, '广西壮族自治区', '广西壮族自治区', 1, '450000', '108.327537', '22.816659');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2447, 2446, '百色市', '百色市', 2, '451000', '106.61869', '23.90307');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2448, 2447, '乐业县', '乐业县', 3, '451028', '106.556564', '24.776812');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2449, 2447, '凌云县', '凌云县', 3, '451027', '106.56114', '24.347444');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2450, 2447, '隆林各族自治县', '隆林各族自治县', 3, '451031', '105.343816', '24.770649');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2451, 2447, '西林县', '西林县', 3, '451030', '105.097229', '24.50762');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2452, 2447, '平果市', '平果市', 3, '451082', '107.589768', '23.329815');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2453, 2447, '右江区', '右江区', 3, '451002', '106.618225', '23.90097');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2454, 2447, '靖西市', '靖西市', 3, '451081', '106.417666', '23.134375');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2455, 2447, '那坡县', '那坡县', 3, '451026', '105.83234', '23.387997');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2456, 2447, '田林县', '田林县', 3, '451029', '106.22874', '24.294627');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2457, 2447, '田东县', '田东县', 3, '451022', '107.125609', '23.596706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2458, 2447, '田阳区', '田阳区', 3, '451003', '106.915424', '23.735631');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2459, 2447, '德保县', '德保县', 3, '451024', '106.615087', '23.324084');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2460, 2446, '北海市', '北海市', 2, '450500', '109.120248', '21.481305');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2461, 2460, '铁山港区', '铁山港区', 3, '450512', '109.422099', '21.529878');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2462, 2460, '银海区', '银海区', 3, '450503', '109.139689', '21.449729');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2463, 2460, '海城区', '海城区', 3, '450502', '109.117256', '21.474914');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2464, 2460, '合浦县', '合浦县', 3, '450521', '109.207236', '21.66132');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2465, 2446, '柳州市', '柳州市', 2, '450200', '109.428071', '24.326442');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2466, 2465, '三江侗族自治县', '三江侗族自治县', 3, '450226', '109.607675', '25.783197');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2467, 2465, '融水苗族自治县', '融水苗族自治县', 3, '450225', '109.256609', '25.066624');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2468, 2465, '融安县', '融安县', 3, '450224', '109.397538', '25.224549');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2469, 2465, '鹿寨县', '鹿寨县', 3, '450223', '109.750527', '24.472897');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2470, 2465, '城中区', '城中区', 3, '450202', '109.427398', '24.366964');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2471, 2465, '柳北区', '柳北区', 3, '450205', '109.402009', '24.362611');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2472, 2465, '柳城县', '柳城县', 3, '450222', '109.267125', '24.654329');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2473, 2465, '鱼峰区', '鱼峰区', 3, '450203', '109.452781', '24.318276');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2474, 2465, '柳南区', '柳南区', 3, '450204', '109.385504', '24.336229');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2475, 2465, '柳江区', '柳江区', 3, '450206', '109.326365', '24.255644');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2476, 2446, '钦州市', '钦州市', 2, '450700', '108.654355', '21.980894');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2477, 2476, '钦南区', '钦南区', 3, '450702', '108.657427', '21.940438');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2478, 2476, '钦北区', '钦北区', 3, '450703', '108.638738', '22.0024');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2479, 2476, '灵山县', '灵山县', 3, '450721', '109.290698', '22.416671');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2480, 2476, '浦北县', '浦北县', 3, '450722', '109.556232', '22.271902');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2481, 2446, '梧州市', '梧州市', 2, '450400', '111.279022', '23.476733');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2482, 2481, '蒙山县', '蒙山县', 3, '450423', '110.525003', '24.193567');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2483, 2481, '岑溪市', '岑溪市', 3, '450481', '110.994955', '22.918327');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2484, 2481, '长洲区', '长洲区', 3, '450405', '111.274276', '23.486279');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2485, 2481, '龙圩区', '龙圩区', 3, '450406', '111.247514', '23.414869');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2486, 2481, '万秀区', '万秀区', 3, '450403', '111.318065', '23.470543');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2487, 2481, '苍梧县', '苍梧县', 3, '450421', '111.547244', '23.868208');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2488, 2481, '藤县', '藤县', 3, '450422', '110.914606', '23.375538');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2489, 2446, '桂林市', '桂林市', 2, '450300', '110.179752', '25.235615');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2490, 2489, '雁山区', '雁山区', 3, '450311', '110.286611', '25.101798');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2491, 2489, '阳朔县', '阳朔县', 3, '450321', '110.496305', '24.778785');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2492, 2489, '七星区', '七星区', 3, '450305', '110.317576', '25.253093');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2493, 2489, '荔浦市', '荔浦市', 3, '450381', '110.395232', '24.48843');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2494, 2489, '龙胜各族自治县', '龙胜各族自治县', 3, '450328', '110.011662', '25.79803');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2495, 2489, '秀峰区', '秀峰区', 3, '450302', '110.264102', '25.273954');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2496, 2489, '灌阳县', '灌阳县', 3, '450327', '111.160764', '25.489419');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2497, 2489, '象山区', '象山区', 3, '450304', '110.281223', '25.261585');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2498, 2489, '叠彩区', '叠彩区', 3, '450303', '110.301489', '25.314158');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2499, 2489, '灵川县', '灵川县', 3, '450323', '110.319837', '25.3948');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2500, 2489, '资源县', '资源县', 3, '450329', '110.652612', '26.042452');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2501, 2489, '平乐县', '平乐县', 3, '450330', '110.632867', '24.622814');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2502, 2489, '恭城瑶族自治县', '恭城瑶族自治县', 3, '450332', '110.82841', '24.831581');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2503, 2489, '兴安县', '兴安县', 3, '450325', '110.672013', '25.612576');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2504, 2489, '全州县', '全州县', 3, '450324', '111.087089', '25.94939');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2505, 2489, '永福县', '永福县', 3, '450326', '109.982974', '24.980447');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2506, 2489, '临桂区', '临桂区', 3, '450312', '110.212425', '25.238556');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2507, 2446, '贺州市', '贺州市', 2, '451100', '111.567216', '24.404182');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2508, 2507, '富川瑶族自治县', '富川瑶族自治县', 3, '451123', '111.296012', '24.811601');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2509, 2507, '昭平县', '昭平县', 3, '451121', '110.811158', '24.169675');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2510, 2507, '钟山县', '钟山县', 3, '451122', '111.303085', '24.526041');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2511, 2507, '平桂区', '平桂区', 3, '451103', '111.479839', '24.453094');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2512, 2507, '八步区', '八步区', 3, '451102', '111.552029', '24.411822');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2513, 2446, '河池市', '河池市', 2, '451200', '108.085244', '24.692906');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2514, 2513, '南丹县', '南丹县', 3, '451221', '107.540578', '24.975066');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2515, 2513, '环江毛南族自治县', '环江毛南族自治县', 3, '451226', '108.258426', '24.825923');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2516, 2513, '天峨县', '天峨县', 3, '451222', '107.172287', '24.999181');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2517, 2513, '罗城仫佬族自治县', '罗城仫佬族自治县', 3, '451225', '108.904613', '24.777501');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2518, 2513, '都安瑶族自治县', '都安瑶族自治县', 3, '451228', '108.105229', '23.932704');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2519, 2513, '金城江区', '金城江区', 3, '451202', '108.037384', '24.689475');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2520, 2513, '凤山县', '凤山县', 3, '451223', '107.042157', '24.546913');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2521, 2513, '宜州区', '宜州区', 3, '451203', '108.611303', '24.500981');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2522, 2513, '大化瑶族自治县', '大化瑶族自治县', 3, '451229', '107.998151', '23.735699');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2523, 2513, '东兰县', '东兰县', 3, '451224', '107.374259', '24.510698');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2524, 2513, '巴马瑶族自治县', '巴马瑶族自治县', 3, '451227', '107.258671', '24.142216');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2525, 2446, '来宾市', '来宾市', 2, '451300', '109.221243', '23.750105');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2526, 2525, '金秀瑶族自治县', '金秀瑶族自治县', 3, '451324', '110.190354', '24.130509');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2527, 2525, '合山市', '合山市', 3, '451381', '108.885829', '23.807032');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2528, 2525, '忻城县', '忻城县', 3, '451321', '108.665641', '24.066176');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2529, 2525, '兴宾区', '兴宾区', 3, '451302', '109.183284', '23.727647');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2530, 2525, '象州县', '象州县', 3, '451322', '109.704852', '23.973832');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2531, 2525, '武宣县', '武宣县', 3, '451323', '109.663153', '23.594444');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2532, 2446, '防城港市', '防城港市', 2, '450600', '108.35467', '21.686732');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2533, 2532, '港口区', '港口区', 3, '450602', '108.380273', '21.643426');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2534, 2532, '防城区', '防城区', 3, '450603', '108.353978', '21.768826');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2535, 2532, '东兴市', '东兴市', 3, '450681', '107.971828', '21.547821');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2536, 2532, '上思县', '上思县', 3, '450621', '107.983627', '22.153671');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2537, 2446, '玉林市', '玉林市', 2, '450900', '110.18097', '22.654001');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2538, 2537, '福绵区', '福绵区', 3, '450903', '110.059564', '22.585316');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2539, 2537, '博白县', '博白县', 3, '450923', '109.975856', '22.273539');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2540, 2537, '陆川县', '陆川县', 3, '450922', '110.26412', '22.321563');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2541, 2537, '北流市', '北流市', 3, '450981', '110.353765', '22.708415');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2542, 2537, '容县', '容县', 3, '450921', '110.558093', '22.85844');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2543, 2537, '玉州区', '玉州区', 3, '450902', '110.150717', '22.628476');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2544, 2537, '兴业县', '兴业县', 3, '450924', '109.875223', '22.736395');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2545, 2446, '南宁市', '南宁市', 2, '450100', '108.366407', '22.8177');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2546, 2545, '上林县', '上林县', 3, '450125', '108.605089', '23.432451');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2547, 2545, '马山县', '马山县', 3, '450124', '108.177764', '23.708448');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2548, 2545, '宾阳县', '宾阳县', 3, '450126', '108.810336', '23.217771');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2549, 2545, '武鸣区', '武鸣区', 3, '450110', '108.274869', '23.159257');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2550, 2545, '江南区', '江南区', 3, '450105', '108.273206', '22.781166');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2551, 2545, '邕宁区', '邕宁区', 3, '450109', '108.487438', '22.758633');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2552, 2545, '良庆区', '良庆区', 3, '450108', '108.393889', '22.753613');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2553, 2545, '青秀区', '青秀区', 3, '450103', '108.495204', '22.785833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2554, 2545, '兴宁区', '兴宁区', 3, '450102', '108.368071', '22.85354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2555, 2545, '西乡塘区', '西乡塘区', 3, '450107', '108.31344', '22.833852');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2556, 2545, '隆安县', '隆安县', 3, '450123', '107.695721', '23.166356');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2557, 2545, '横州市', '横州市', 3, '450127', '109.262448', '22.681257');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2558, 2446, '贵港市', '贵港市', 2, '450800', '109.598903', '23.11182');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2559, 2558, '港北区', '港北区', 3, '450802', '109.572227', '23.11136');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2560, 2558, '港南区', '港南区', 3, '450803', '109.599357', '23.075816');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2561, 2558, '平南县', '平南县', 3, '450821', '110.392489', '23.540413');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2562, 2558, '桂平市', '桂平市', 3, '450881', '110.079315', '23.394208');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2563, 2558, '覃塘区', '覃塘区', 3, '450804', '109.452668', '23.127405');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2564, 2446, '崇左市', '崇左市', 2, '451400', '107.364973', '22.377139');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2565, 2564, '扶绥县', '扶绥县', 3, '451421', '107.90389', '22.635542');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2566, 2564, '江州区', '江州区', 3, '451402', '107.353694', '22.40609');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2567, 2564, '凭祥市', '凭祥市', 3, '451481', '106.766715', '22.094421');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2568, 2564, '龙州县', '龙州县', 3, '451423', '106.854001', '22.343591');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2569, 2564, '大新县', '大新县', 3, '451424', '107.200654', '22.829287');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2570, 2564, '宁明县', '宁明县', 3, '451422', '107.076394', '22.140242');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2571, 2564, '天等县', '天等县', 3, '451425', '107.143539', '23.080818');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2572, 0, '宁夏回族自治区', '宁夏回族自治区', 1, '640000', '106.258889', '38.472273');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2573, 2572, '石嘴山市', '石嘴山市', 2, '640200', '106.382792', '38.984632');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2574, 2573, '惠农区', '惠农区', 3, '640205', '106.781013', '39.239292');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2575, 2573, '大武口区', '大武口区', 3, '640202', '106.368128', '39.019375');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2576, 2573, '平罗县', '平罗县', 3, '640221', '106.523411', '38.913923');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2577, 2572, '固原市', '固原市', 2, '640400', '106.24267', '36.01628');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2578, 2577, '隆德县', '隆德县', 3, '640423', '106.111321', '35.62592');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2579, 2577, '彭阳县', '彭阳县', 3, '640425', '106.632151', '35.860067');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2580, 2577, '泾源县', '泾源县', 3, '640424', '106.330569', '35.497887');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2581, 2577, '西吉县', '西吉县', 3, '640422', '105.729189', '35.963885');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2582, 2577, '原州区', '原州区', 3, '640402', '106.28784', '36.003777');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2583, 2572, '中卫市', '中卫市', 2, '640500', '105.19677', '37.500185');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2584, 2583, '海原县', '海原县', 3, '640522', '105.643449', '36.565189');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2585, 2583, '沙坡头区', '沙坡头区', 3, '640502', '105.173875', '37.516859');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2586, 2583, '中宁县', '中宁县', 3, '640521', '105.684729', '37.492092');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2587, 2572, '吴忠市', '吴忠市', 2, '640300', '106.198613', '37.997755');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2588, 2587, '青铜峡市', '青铜峡市', 3, '640381', '106.07906', '38.021579');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2589, 2587, '同心县', '同心县', 3, '640324', '105.895412', '36.954635');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2590, 2587, '盐池县', '盐池县', 3, '640323', '107.407184', '37.783276');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2591, 2587, '利通区', '利通区', 3, '640302', '106.212479', '37.984586');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2592, 2587, '红寺堡区', '红寺堡区', 3, '640303', '106.06216', '37.425494');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2593, 2572, '银川市', '银川市', 2, '640100', '106.230977', '38.487783');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2594, 2593, '永宁县', '永宁县', 3, '640121', '106.25337', '38.277376');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2595, 2593, '西夏区', '西夏区', 3, '640105', '106.161208', '38.502325');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2596, 2593, '兴庆区', '兴庆区', 3, '640104', '106.288452', '38.473972');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2597, 2593, '灵武市', '灵武市', 3, '640181', '106.339978', '38.102456');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2598, 2593, '金凤区', '金凤区', 3, '640106', '106.239339', '38.474277');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2599, 2593, '贺兰县', '贺兰县', 3, '640122', '106.365074', '38.579147');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2600, 0, '浙江省', '浙江省', 1, '330000', '120.152575', '30.266619');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2601, 2600, '舟山市', '舟山市', 2, '330900', '122.207395', '29.985578');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2602, 2601, '普陀区', '普陀区', 3, '330903', '122.323297', '29.970571');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2603, 2601, '岱山县', '岱山县', 3, '330921', '122.225718', '30.264533');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2604, 2601, '嵊泗县', '嵊泗县', 3, '330922', '122.45132', '30.725677');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2605, 2601, '定海区', '定海区', 3, '330902', '122.106844', '30.019795');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2606, 2600, '嘉兴市', '嘉兴市', 2, '330400', '120.755623', '30.746814');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2607, 2606, '平湖市', '平湖市', 3, '330482', '121.015619', '30.677804');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2608, 2606, '南湖区', '南湖区', 3, '330402', '120.782952', '30.747738');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2609, 2606, '嘉善县', '嘉善县', 3, '330421', '120.926031', '30.83085');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2610, 2606, '海盐县', '海盐县', 3, '330424', '120.94628', '30.52664');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2611, 2606, '秀洲区', '秀洲区', 3, '330411', '120.709047', '30.764811');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2612, 2606, '桐乡市', '桐乡市', 3, '330483', '120.565127', '30.630375');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2613, 2606, '海宁市', '海宁市', 3, '330481', '120.680224', '30.511536');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2614, 2600, '宁波市', '宁波市', 2, '330200', '121.62454', '29.860258');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2615, 2614, '北仑区', '北仑区', 3, '330206', '121.844601', '29.899548');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2616, 2614, '象山县', '象山县', 3, '330225', '121.869251', '29.476826');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2617, 2614, '江北区', '江北区', 3, '330205', '121.555067', '29.88673');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2618, 2614, '镇海区', '镇海区', 3, '330211', '121.596686', '29.965212');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2619, 2614, '宁海县', '宁海县', 3, '330226', '121.429729', '29.287929');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2620, 2614, '海曙区', '海曙区', 3, '330203', '121.550485', '29.873705');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2621, 2614, '鄞州区', '鄞州区', 3, '330212', '121.546617', '29.817302');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2622, 2614, '奉化区', '奉化区', 3, '330213', '121.406151', '29.655292');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2623, 2614, '慈溪市', '慈溪市', 3, '330282', '121.266525', '30.170695');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2624, 2614, '余姚市', '余姚市', 3, '330281', '121.154572', '30.037967');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2625, 2600, '台州市', '台州市', 2, '331000', '121.42079', '28.655716');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2626, 2625, '路桥区', '路桥区', 3, '331004', '121.337874', '28.578244');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2627, 2625, '椒江区', '椒江区', 3, '331002', '121.442859', '28.673334');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2628, 2625, '临海市', '临海市', 3, '331082', '121.144625', '28.859042');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2629, 2625, '玉环市', '玉环市', 3, '331083', '121.231915', '28.136703');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2630, 2625, '温岭市', '温岭市', 3, '331081', '121.385435', '28.372805');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2631, 2625, '三门县', '三门县', 3, '331022', '121.39561', '29.104888');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2632, 2625, '天台县', '天台县', 3, '331023', '121.006657', '29.144594');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2633, 2625, '仙居县', '仙居县', 3, '331024', '120.728733', '28.846856');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2634, 2625, '黄岩区', '黄岩区', 3, '331003', '121.261804', '28.649433');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2635, 2600, '温州市', '温州市', 2, '330300', '120.699279', '27.993849');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2636, 2635, '洞头区', '洞头区', 3, '330305', '121.157406', '27.836412');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2637, 2635, '苍南县', '苍南县', 3, '330327', '120.425957', '27.518636');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2638, 2635, '龙港市', '龙港市', 3, '330383', '120.552952', '27.578379');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2639, 2635, '平阳县', '平阳县', 3, '330326', '120.565161', '27.662394');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2640, 2635, '瑞安市', '瑞安市', 3, '330381', '120.655245', '27.778967');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2641, 2635, '文成县', '文成县', 3, '330328', '120.090929', '27.786856');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2642, 2635, '泰顺县', '泰顺县', 3, '330329', '119.717643', '27.556578');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2643, 2635, '永嘉县', '永嘉县', 3, '330324', '120.69136', '28.153914');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2644, 2635, '乐清市', '乐清市', 3, '330382', '120.986297', '28.112519');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2645, 2635, '龙湾区', '龙湾区', 3, '330303', '120.812333', '27.933261');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2646, 2635, '鹿城区', '鹿城区', 3, '330302', '120.655199', '28.015776');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2647, 2635, '瓯海区', '瓯海区', 3, '330304', '120.615149', '27.967445');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2648, 2600, '丽水市', '丽水市', 2, '331100', '119.923249', '28.467694');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2649, 2648, '松阳县', '松阳县', 3, '331124', '119.481406', '28.448883');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2650, 2648, '龙泉市', '龙泉市', 3, '331181', '119.14126', '28.074916');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2651, 2648, '莲都区', '莲都区', 3, '331102', '119.912266', '28.4461');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2652, 2648, '云和县', '云和县', 3, '331125', '119.573454', '28.116024');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2653, 2648, '景宁畲族自治县', '景宁畲族自治县', 3, '331127', '119.635686', '27.973594');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2654, 2648, '遂昌县', '遂昌县', 3, '331123', '119.275865', '28.592388');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2655, 2648, '青田县', '青田县', 3, '331121', '120.289693', '28.1396');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2656, 2648, '庆元县', '庆元县', 3, '331126', '119.062572', '27.619213');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2657, 2648, '缙云县', '缙云县', 3, '331122', '120.091685', '28.659294');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2658, 2600, '金华市', '金华市', 2, '330700', '119.647265', '29.079195');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2659, 2658, '永康市', '永康市', 3, '330784', '120.047356', '28.88899');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2660, 2658, '磐安县', '磐安县', 3, '330727', '120.449937', '29.054491');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2661, 2658, '武义县', '武义县', 3, '330723', '119.816341', '28.892562');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2662, 2658, '东阳市', '东阳市', 3, '330783', '120.24179', '29.290158');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2663, 2658, '义乌市', '义乌市', 3, '330782', '120.075679', '29.306296');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2664, 2658, '金东区', '金东区', 3, '330703', '119.692821', '29.099822');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2665, 2658, '婺城区', '婺城区', 3, '330702', '119.571574', '29.087311');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2666, 2658, '兰溪市', '兰溪市', 3, '330781', '119.460404', '29.209059');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2667, 2658, '浦江县', '浦江县', 3, '330726', '119.89259', '29.453363');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2668, 2600, '湖州市', '湖州市', 2, '330500', '120.086881', '30.894178');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2669, 2668, '长兴县', '长兴县', 3, '330522', '119.911212', '31.026962');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2670, 2668, '吴兴区', '吴兴区', 3, '330502', '120.185608', '30.857184');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2671, 2668, '南浔区', '南浔区', 3, '330503', '120.418244', '30.850835');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2672, 2668, '安吉县', '安吉县', 3, '330523', '119.680261', '30.638803');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2673, 2668, '德清县', '德清县', 3, '330521', '119.9774', '30.54251');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2674, 2600, '绍兴市', '绍兴市', 2, '330600', '120.582886', '30.051549');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2675, 2674, '嵊州市', '嵊州市', 3, '330683', '120.830505', '29.561519');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2676, 2674, '新昌县', '新昌县', 3, '330624', '120.903918', '29.500525');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2677, 2674, '诸暨市', '诸暨市', 3, '330681', '120.246602', '29.709398');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2678, 2674, '上虞区', '上虞区', 3, '330604', '120.868571', '30.033862');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2679, 2674, '越城区', '越城区', 3, '330602', '120.582338', '29.989092');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2680, 2674, '柯桥区', '柯桥区', 3, '330603', '120.495532', '30.083039');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2681, 2600, '衢州市', '衢州市', 2, '330800', '118.859307', '28.970229');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2682, 2681, '柯城区', '柯城区', 3, '330802', '118.874138', '28.936937');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2683, 2681, '江山市', '江山市', 3, '330881', '118.627228', '28.73796');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2684, 2681, '龙游县', '龙游县', 3, '330825', '119.1723', '29.028214');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2685, 2681, '衢江区', '衢江区', 3, '330803', '118.959139', '28.980356');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2686, 2681, '常山县', '常山县', 3, '330822', '118.511224', '28.902446');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2687, 2681, '开化县', '开化县', 3, '330824', '118.415756', '29.136729');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2688, 2600, '杭州市', '杭州市', 2, '330100', '120.210792', '30.246026');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2689, 2688, '富阳区', '富阳区', 3, '330111', '119.96022', '30.048803');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2690, 2688, '淳安县', '淳安县', 3, '330127', '119.042015', '29.609678');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2691, 2688, '上城区', '上城区', 3, '330102', '120.19732', '30.226543');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2692, 2688, '桐庐县', '桐庐县', 3, '330122', '119.691755', '29.79418');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2693, 2688, '建德市', '建德市', 3, '330182', '119.281195', '29.474964');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2694, 2688, '滨江区', '滨江区', 3, '330108', '120.211981', '30.208332');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2695, 2688, '拱墅区', '拱墅区', 3, '330105', '120.141503', '30.319126');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2696, 2688, '钱塘区', '钱塘区', 3, '330114', '120.493941', '30.32304');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2697, 2688, '萧山区', '萧山区', 3, '330109', '120.264263', '30.184119');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2698, 2688, '西湖区', '西湖区', 3, '330106', '120.130396', '30.259242');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2699, 2688, '临安区', '临安区', 3, '330112', '119.724457', '30.234375');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2700, 2688, '临平区', '临平区', 3, '330113', '120.299222', '30.419154');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2701, 2688, '余杭区', '余杭区', 3, '330110', '119.978742', '30.273705');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2702, 0, '河北省', '河北省', 1, '130000', '114.530399', '38.037707');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2703, 2702, '唐山市', '唐山市', 2, '130200', '118.180149', '39.63068');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2704, 2703, '滦州市', '滦州市', 3, '130284', '118.70301', '39.740963');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2705, 2703, '遵化市', '遵化市', 3, '130281', '117.965878', '40.189119');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2706, 2703, '迁安市', '迁安市', 3, '130283', '118.701021', '39.998861');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2707, 2703, '迁西县', '迁西县', 3, '130227', '118.31467', '40.141486');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2708, 2703, '滦南县', '滦南县', 3, '130224', '118.68363', '39.520272');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2709, 2703, '曹妃甸区', '曹妃甸区', 3, '130209', '118.460197', '39.273528');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2710, 2703, '乐亭县', '乐亭县', 3, '130225', '118.91245', '39.425748');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2711, 2703, '玉田县', '玉田县', 3, '130229', '117.738196', '39.901827');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2712, 2703, '路南区', '路南区', 3, '130202', '118.154348', '39.624988');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2713, 2703, '古冶区', '古冶区', 3, '130204', '118.447134', '39.73392');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2714, 2703, '开平区', '开平区', 3, '130205', '118.262246', '39.671634');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2715, 2703, '丰南区', '丰南区', 3, '130207', '118.085169', '39.576031');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2716, 2703, '丰润区', '丰润区', 3, '130208', '118.162426', '39.832919');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2717, 2703, '路北区', '路北区', 3, '130203', '118.201085', '39.625079');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2718, 2702, '廊坊市', '廊坊市', 2, '131000', '116.683546', '39.538304');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2719, 2718, '大厂回族自治县', '大厂回族自治县', 3, '131028', '116.98961', '39.886569');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2720, 2718, '大城县', '大城县', 3, '131025', '116.653917', '38.705232');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2721, 2718, '永清县', '永清县', 3, '131023', '116.50608', '39.330983');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2722, 2718, '固安县', '固安县', 3, '131022', '116.298745', '39.4382');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2723, 2718, '香河县', '香河县', 3, '131024', '117.006072', '39.763772');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2724, 2718, '文安县', '文安县', 3, '131026', '116.457628', '38.873185');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2725, 2718, '三河市', '三河市', 3, '131082', '117.078269', '39.982933');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2726, 2718, '广阳区', '广阳区', 3, '131003', '116.710667', '39.52343');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2727, 2718, '安次区', '安次区', 3, '131002', '116.6945443', '39.50256863');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2728, 2718, '霸州市', '霸州市', 3, '131081', '116.391488', '39.125238');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2729, 2702, '秦皇岛市', '秦皇岛市', 2, '130300', '119.52022', '39.888243');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2730, 2729, '青龙满族自治县', '青龙满族自治县', 3, '130321', '118.94985', '40.407473');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2731, 2729, '山海关区', '山海关区', 3, '130303', '119.775187', '39.978882');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2732, 2729, '卢龙县', '卢龙县', 3, '130324', '118.891931', '39.892564');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2733, 2729, '北戴河区', '北戴河区', 3, '130304', '119.48449', '39.834912');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2734, 2729, '抚宁区', '抚宁区', 3, '130306', '119.244847', '39.876253');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2735, 2729, '海港区', '海港区', 3, '130302', '119.564962', '39.94756');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2736, 2729, '昌黎县', '昌黎县', 3, '130322', '119.199846', '39.699677');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2737, 2702, '张家口市', '张家口市', 2, '130700', '114.885895', '40.768931');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2738, 2737, '沽源县', '沽源县', 3, '130724', '115.688544', '41.670497');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2739, 2737, '康保县', '康保县', 3, '130723', '114.60018', '41.853016');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2740, 2737, '尚义县', '尚义县', 3, '130725', '113.968763', '41.076588');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2741, 2737, '下花园区', '下花园区', 3, '130706', '115.287127', '40.502628');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2742, 2737, '崇礼区', '崇礼区', 3, '130709', '115.282345', '40.974741');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2743, 2737, '赤城县', '赤城县', 3, '130732', '115.831256', '40.913348');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2744, 2737, '张北县', '张北县', 3, '130722', '114.719927', '41.159039');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2745, 2737, '万全区', '万全区', 3, '130708', '114.740584', '40.767377');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2746, 2737, '怀来县', '怀来县', 3, '130730', '115.517868', '40.415625');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2747, 2737, '涿鹿县', '涿鹿县', 3, '130731', '115.196835', '40.382681');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2748, 2737, '桥西区', '桥西区', 3, '130703', '114.868604', '40.819553');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2749, 2737, '桥东区', '桥东区', 3, '130702', '114.894114', '40.788472');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2750, 2737, '宣化区', '宣化区', 3, '130705', '115.099515', '40.609444');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2751, 2737, '怀安县', '怀安县', 3, '130728', '114.386488', '40.67527');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2752, 2737, '蔚县', '蔚县', 3, '130726', '114.589136', '39.840154');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2753, 2737, '阳原县', '阳原县', 3, '130727', '114.150267', '40.104303');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2754, 2702, '邯郸市', '邯郸市', 2, '130400', '114.53915', '36.625849');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2755, 2754, '肥乡区', '肥乡区', 3, '130407', '114.800199', '36.548545');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2756, 2754, '涉县', '涉县', 3, '130426', '113.692157', '36.586073');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2757, 2754, '魏县', '魏县', 3, '130434', '114.939217', '36.35926');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2758, 2754, '临漳县', '临漳县', 3, '130423', '114.585514', '36.322504');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2759, 2754, '鸡泽县', '鸡泽县', 3, '130431', '114.889951', '36.911525');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2760, 2754, '曲周县', '曲周县', 3, '130435', '114.957549', '36.766347');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2761, 2754, '磁县', '磁县', 3, '130427', '114.373965', '36.37507');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2762, 2754, '丛台区', '丛台区', 3, '130403', '114.492875', '36.636434');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2763, 2754, '永年区', '永年区', 3, '130408', '114.536626', '36.74188');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2764, 2754, '复兴区', '复兴区', 3, '130404', '114.462581', '36.638879');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2765, 2754, '成安县', '成安县', 3, '130424', '114.670094', '36.445331');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2766, 2754, '邯山区', '邯山区', 3, '130402', '114.531062', '36.59457');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2767, 2754, '馆陶县', '馆陶县', 3, '130433', '115.281818', '36.548295');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2768, 2754, '邱县', '邱县', 3, '130430', '115.200049', '36.811783');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2769, 2754, '大名县', '大名县', 3, '130425', '115.147985', '36.286406');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2770, 2754, '广平县', '广平县', 3, '130432', '114.948638', '36.48382');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2771, 2754, '峰峰矿区', '峰峰矿区', 3, '130406', '114.212571', '36.419298');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2772, 2754, '武安市', '武安市', 3, '130481', '114.203685', '36.69759');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2773, 2702, '石家庄市', '石家庄市', 2, '130100', '114.514976', '38.042007');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2774, 2773, '平山县', '平山县', 3, '130131', '114.186007', '38.260288');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2775, 2773, '灵寿县', '灵寿县', 3, '130126', '114.383013', '38.307908');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2776, 2773, '无极县', '无极县', 3, '130130', '114.976256', '38.178852');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2777, 2773, '正定县', '正定县', 3, '130123', '114.57043', '38.14699');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2778, 2773, '鹿泉区', '鹿泉区', 3, '130110', '114.313559', '38.086536');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2779, 2773, '晋州市', '晋州市', 3, '130183', '115.044141', '38.033937');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2780, 2773, '藁城区', '藁城区', 3, '130109', '114.846562', '38.022177');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2781, 2773, '元氏县', '元氏县', 3, '130132', '114.525508', '37.767332');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2782, 2773, '裕华区', '裕华区', 3, '130108', '114.531599', '38.007002');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2783, 2773, '赞皇县', '赞皇县', 3, '130129', '114.386114', '37.666549');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2784, 2773, '高邑县', '高邑县', 3, '130127', '114.611659', '37.615905');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2785, 2773, '井陉县', '井陉县', 3, '130121', '114.145669', '38.032366');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2786, 2773, '新华区', '新华区', 3, '130105', '114.463904', '38.050749');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2787, 2773, '新乐市', '新乐市', 3, '130184', '114.683745', '38.343952');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2788, 2773, '辛集市', '辛集市', 3, '130181', '115.217626', '37.943239');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2789, 2773, '井陉矿区', '井陉矿区', 3, '130107', '114.062258', '38.065446');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2790, 2773, '深泽县', '深泽县', 3, '130128', '115.20089', '38.184572');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2791, 2773, '栾城区', '栾城区', 3, '130111', '114.647922', '37.900915');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2792, 2773, '赵县', '赵县', 3, '130133', '114.775914', '37.756935');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2793, 2773, '行唐县', '行唐县', 3, '130125', '114.553044', '38.437535');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2794, 2773, '长安区', '长安区', 3, '130102', '114.538955', '38.03682');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2795, 2773, '桥西区', '桥西区', 3, '130104', '114.45004', '38.025245');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2796, 2702, '保定市', '保定市', 2, '130600', '115.464523', '38.874476');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2797, 2796, '涞源县', '涞源县', 3, '130630', '114.694416', '39.360622');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2798, 2796, '易县', '易县', 3, '130633', '115.497487', '39.350219');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2799, 2796, '顺平县', '顺平县', 3, '130636', '115.135133', '38.837988');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2800, 2796, '徐水区', '徐水区', 3, '130609', '115.655772', '39.018781');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2801, 2796, '安新县', '安新县', 3, '130632', '115.935688', '38.936102');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2802, 2796, '高阳县', '高阳县', 3, '130628', '115.779149', '38.700846');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2803, 2796, '竞秀区', '竞秀区', 3, '130602', '115.458671', '38.877318');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2804, 2796, '安国市', '安国市', 3, '130683', '115.327088', '38.418985');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2805, 2796, '定州市', '定州市', 3, '130682', '114.990321', '38.516746');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2806, 2796, '莲池区', '莲池区', 3, '130606', '115.497153', '38.883528');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2807, 2796, '涞水县', '涞水县', 3, '130623', '115.713651', '39.394305');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2808, 2796, '涿州市', '涿州市', 3, '130681', '115.97444', '39.485684');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2809, 2796, '蠡县', '蠡县', 3, '130635', '115.583701', '38.488064');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2810, 2796, '博野县', '博野县', 3, '130637', '115.464295', '38.458048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2811, 2796, '望都县', '望都县', 3, '130631', '115.15542', '38.696221');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2812, 2796, '阜平县', '阜平县', 3, '130624', '114.195118', '38.849221');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2813, 2796, '唐县', '唐县', 3, '130627', '114.982968', '38.748477');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2814, 2796, '曲阳县', '曲阳县', 3, '130634', '114.740476', '38.614409');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2815, 2796, '高碑店市', '高碑店市', 3, '130684', '115.873612', '39.327233');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2816, 2796, '定兴县', '定兴县', 3, '130626', '115.808183', '39.263219');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2817, 2796, '容城县', '容城县', 3, '130629', '115.861635', '39.043321');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2818, 2796, '雄县', '雄县', 3, '130638', '116.108624', '38.994825');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2819, 2796, '满城区', '满城区', 3, '130607', '115.322246', '38.949732');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2820, 2796, '清苑区', '清苑区', 3, '130608', '115.48988', '38.76527');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2821, 2702, '承德市', '承德市', 2, '130800', '117.962749', '40.952942');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2822, 2821, '围场满族蒙古族自治县', '围场满族蒙古族自治县', 3, '130828', '117.75934', '41.938372');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2823, 2821, '丰宁满族自治县', '丰宁满族自治县', 3, '130826', '116.645798', '41.209951');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2824, 2821, '隆化县', '隆化县', 3, '130825', '117.739026', '41.314402');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2825, 2821, '宽城满族自治县', '宽城满族自治县', 3, '130827', '118.485472', '40.611333');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2826, 2821, '鹰手营子矿区', '鹰手营子矿区', 3, '130804', '117.659341', '40.546424');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2827, 2821, '兴隆县', '兴隆县', 3, '130822', '117.500558', '40.417358');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2828, 2821, '平泉市', '平泉市', 3, '130881', '118.702032', '41.018482');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2829, 2821, '双滦区', '双滦区', 3, '130803', '117.799588', '40.959426');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2830, 2821, '滦平县', '滦平县', 3, '130824', '117.332652', '40.941644');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2831, 2821, '承德县', '承德县', 3, '130821', '118.174166', '40.768082');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2832, 2821, '双桥区', '双桥区', 3, '130802', '117.943121', '40.974679');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2833, 2702, '邢台市', '邢台市', 2, '130500', '114.49742', '37.060227');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2834, 2833, '南宫市', '南宫市', 3, '130581', '115.40866', '37.358907');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2835, 2833, '临城县', '临城县', 3, '130522', '114.498651', '37.444512');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2836, 2833, '柏乡县', '柏乡县', 3, '130524', '114.693447', '37.48288');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2837, 2833, '新河县', '新河县', 3, '130530', '115.251005', '37.520891');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2838, 2833, '内丘县', '内丘县', 3, '130523', '114.512226', '37.287612');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2839, 2833, '清河县', '清河县', 3, '130534', '115.665081', '37.0451');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2840, 2833, '平乡县', '平乡县', 3, '130532', '115.03008', '37.063771');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2841, 2833, '沙河市', '沙河市', 3, '130582', '114.503023', '36.855548');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2842, 2833, '广宗县', '广宗县', 3, '130531', '115.142766', '37.074795');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2843, 2833, '南和区', '南和区', 3, '130506', '114.683683', '37.005626');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2844, 2833, '宁晋县', '宁晋县', 3, '130528', '114.940006', '37.624524');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2845, 2833, '隆尧县', '隆尧县', 3, '130525', '114.770509', '37.351232');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2846, 2833, '任泽区', '任泽区', 3, '130505', '114.671339', '37.121958');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2847, 2833, '巨鹿县', '巨鹿县', 3, '130529', '115.037884', '37.221293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2848, 2833, '信都区', '信都区', 3, '130503', '114.468229', '37.093798');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2849, 2833, '襄都区', '襄都区', 3, '130502', '114.507443', '37.071314');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2850, 2833, '威县', '威县', 3, '130533', '115.266829', '36.975164');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2851, 2833, '临西县', '临西县', 3, '130535', '115.501258', '36.871312');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2852, 2702, '衡水市', '衡水市', 2, '131100', '115.668987', '37.739367');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2853, 2852, '桃城区', '桃城区', 3, '131102', '115.675208', '37.735152');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2854, 2852, '枣强县', '枣强县', 3, '131121', '115.724365', '37.514217');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2855, 2852, '深州市', '深州市', 3, '131182', '115.559576', '38.001535');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2856, 2852, '饶阳县', '饶阳县', 3, '131124', '115.725898', '38.235313');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2857, 2852, '安平县', '安平县', 3, '131125', '115.518918', '38.234769');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2858, 2852, '阜城县', '阜城县', 3, '131128', '116.175424', '37.862984');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2859, 2852, '冀州区', '冀州区', 3, '131103', '115.579392', '37.550922');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2860, 2852, '故城县', '故城县', 3, '131126', '115.965877', '37.347873');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2861, 2852, '景县', '景县', 3, '131127', '116.270558', '37.692831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2862, 2852, '武邑县', '武邑县', 3, '131122', '115.887498', '37.802036');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2863, 2852, '武强县', '武强县', 3, '131123', '115.982119', '38.041447');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2864, 2702, '沧州市', '沧州市', 2, '130900', '116.838715', '38.304676');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2865, 2864, '任丘市', '任丘市', 3, '130982', '116.084412', '38.685325');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2866, 2864, '献县', '献县', 3, '130929', '116.122767', '38.189924');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2867, 2864, '运河区', '运河区', 3, '130903', '116.842964', '38.283456');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2868, 2864, '南皮县', '南皮县', 3, '130927', '116.708603', '38.038761');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2869, 2864, '海兴县', '海兴县', 3, '130924', '117.497545', '38.143308');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2870, 2864, '东光县', '东光县', 3, '130923', '116.537138', '37.888844');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2871, 2864, '吴桥县', '吴桥县', 3, '130928', '116.391557', '37.628225');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2872, 2864, '黄骅市', '黄骅市', 3, '130983', '117.330043', '38.372266');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2873, 2864, '青县', '青县', 3, '130922', '116.804137', '38.583657');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2874, 2864, '肃宁县', '肃宁县', 3, '130926', '115.829619', '38.423044');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2875, 2864, '河间市', '河间市', 3, '130984', '116.099362', '38.446656');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2876, 2864, '孟村回族自治县', '孟村回族自治县', 3, '130930', '117.104514', '38.053438');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2877, 2864, '盐山县', '盐山县', 3, '130925', '117.230681', '38.058074');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2878, 2864, '新华区', '新华区', 3, '130902', '116.866309', '38.314094');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2879, 2864, '沧县', '沧县', 3, '130921', '117.007478', '38.21985569');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2880, 2864, '泊头市', '泊头市', 3, '130981', '116.578322', '38.084262');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2881, 0, '香港特别行政区', '香港特别行政区', 1, '810000', '114.173355', '22.320048');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2882, 2881, '大埔区', '大埔区', 2, '810014', '114.1717431', '22.44565306');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2883, 2881, '黄大仙区', '黄大仙区', 2, '810008', '114.2038856', '22.33632056');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2884, 2881, '北区', '北区', 2, '810013', '114.1473639', '22.49610389');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2885, 2881, '西贡区', '西贡区', 2, '810015', '114.264645', '22.31421306');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2886, 2881, '沙田区', '沙田区', 2, '810016', '114.1953653', '22.37953167');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2887, 2881, '屯门区', '屯门区', 2, '810011', '113.9765742', '22.39384417');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2888, 2881, '观塘区', '观塘区', 2, '810009', '114.2140542', '22.32083778');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2889, 2881, '九龙城区', '九龙城区', 2, '810007', '114.1928467', '22.31251');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2890, 2881, '深水埗区', '深水埗区', 2, '810006', '114.1632417', '22.33385417');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2891, 2881, '离岛区', '离岛区', 2, '810018', '113.94612', '22.28640778');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2892, 2881, '湾仔区', '湾仔区', 2, '810002', '114.1829153', '22.27638889');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2893, 2881, '南区', '南区', 2, '810004', '114.1600117', '22.24589667');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2894, 2881, '油尖旺区', '油尖旺区', 2, '810005', '114.1733317', '22.31170389');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2895, 2881, '东区', '东区', 2, '810003', '114.2260031', '22.27969306');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2896, 2881, '中西区', '中西区', 2, '810001', '114.1543731', '22.28198083');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2897, 2881, '元朗区', '元朗区', 2, '810012', '114.0324381', '22.44142833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2898, 2881, '葵青区', '葵青区', 2, '810017', '114.1393194', '22.36387667');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2899, 2881, '荃湾区', '荃湾区', 2, '810010', '114.1210792', '22.36830667');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2900, 0, '台湾省', '台湾省', 1, '710000', '121.509062', '25.044332');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2901, 0, '澳门特别行政区', '澳门特别行政区', 1, '820000', '113.54909', '22.198951');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2902, 2901, '望德堂区', '望德堂区', 2, '820003', '113.5501828', '22.19372083');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2903, 2901, '花王堂区', '花王堂区', 2, '820002', '113.5489608', '22.1992075');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2904, 2901, '嘉模堂区', '嘉模堂区', 2, '820006', '113.5587044', '22.15375944');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2905, 2901, '花地玛堂区', '花地玛堂区', 2, '820001', '113.5528956', '22.20787');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2906, 2901, '圣方济各堂区', '圣方济各堂区', 2, '820008', '113.5599542', '22.12348639');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2907, 2901, '大堂区', '大堂区', 2, '820004', '113.5536475', '22.18853944');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2908, 2901, '风顺堂区', '风顺堂区', 2, '820005', '113.5419278', '22.18736806');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2909, 2901, '路凼填海区', '路凼填海区', 2, '820007', '113.5695992', '22.13663');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2910, 0, '甘肃省', '甘肃省', 1, '620000', '103.826777', '36.060634');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2911, 2910, '嘉峪关市', '嘉峪关市', 2, '620200', '98.2882', '39.77325');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2912, 2911, '峪泉镇', '峪泉镇', 3, '620200', '98.3204', '39.9583');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2913, 2911, '新城镇', '新城镇', 3, '620200', '98.3627', '39.9581');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2914, 2911, '文殊镇', '文殊镇', 3, '620200', '98.1579', '39.6969');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2915, 2911, '钢城街道', '钢城街道', 3, '620200', '98.2926', '39.7558');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2916, 2911, '雄关街道', '雄关街道', 3, '620200', '98.2391', '39.893');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2917, 2910, '酒泉市', '酒泉市', 2, '620900', '98.49432', '39.733416');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2918, 2917, '肃北蒙古族自治县', '肃北蒙古族自治县', 3, '620923', '94.876533', '39.512158');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2919, 2917, '玉门市', '玉门市', 3, '620981', '97.045617', '40.292344');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2920, 2917, '金塔县', '金塔县', 3, '620921', '98.901523', '39.984146');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2921, 2917, '敦煌市', '敦煌市', 3, '620982', '94.66201', '40.142141');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2922, 2917, '肃州区', '肃州区', 3, '620902', '98.507834', '39.74511');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2923, 2917, '阿克塞哈萨克族自治县', '阿克塞哈萨克族自治县', 3, '620924', '94.340202', '39.633944');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2924, 2917, '瓜州县', '瓜州县', 3, '620922', '95.782255', '40.520457');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2925, 2910, '兰州市', '兰州市', 2, '620100', '103.834228', '36.060798');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2926, 2925, '皋兰县', '皋兰县', 3, '620122', '103.947345', '36.332434');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2927, 2925, '西固区', '西固区', 3, '620104', '103.627966', '36.08845');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2928, 2925, '红古区', '红古区', 3, '620111', '102.859338', '36.345768');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2929, 2925, '安宁区', '安宁区', 3, '620105', '103.718953', '36.104493');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2930, 2925, '城关区', '城关区', 3, '620102', '103.825315', '36.056948');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2931, 2925, '七里河区', '七里河区', 3, '620103', '103.786261', '36.066249');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2932, 2925, '榆中县', '榆中县', 3, '620123', '104.112541', '35.843354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2933, 2925, '永登县', '永登县', 3, '620121', '103.260273', '36.736457');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2934, 2910, '金昌市', '金昌市', 2, '620300', '102.187972', '38.521468');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2935, 2934, '金川区', '金川区', 3, '620302', '102.1939', '38.520373');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2936, 2934, '永昌县', '永昌县', 3, '620321', '101.984642', '38.243534');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2937, 2910, '平凉市', '平凉市', 2, '620800', '106.664913', '35.542417');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2938, 2937, '崆峒区', '崆峒区', 3, '620802', '106.67489', '35.542437');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2939, 2937, '崇信县', '崇信县', 3, '620823', '107.025762', '35.305648');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2940, 2937, '庄浪县', '庄浪县', 3, '620825', '106.036201', '35.20266');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2941, 2937, '灵台县', '灵台县', 3, '620822', '107.595874', '35.070027');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2942, 2937, '华亭市', '华亭市', 3, '620881', '106.628899', '35.207695');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2943, 2937, '静宁县', '静宁县', 3, '620826', '105.732165', '35.522035');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2944, 2937, '泾川县', '泾川县', 3, '620821', '107.367608', '35.332992');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2945, 2910, '白银市', '白银市', 2, '620400', '104.138872', '36.545123');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2946, 2945, '平川区', '平川区', 3, '620403', '104.825275', '36.728494');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2947, 2945, '靖远县', '靖远县', 3, '620421', '104.676202', '36.571736');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2948, 2945, '白银区', '白银区', 3, '620402', '104.14956', '36.53469');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2949, 2945, '景泰县', '景泰县', 3, '620423', '104.063125', '37.18351');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2950, 2945, '会宁县', '会宁县', 3, '620422', '105.052883', '35.693241');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2951, 2910, '陇南市', '陇南市', 2, '621200', '104.960296', '33.370174');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2952, 2951, '两当县', '两当县', 3, '621228', '106.304973', '33.908952');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2953, 2951, '礼县', '礼县', 3, '621226', '105.17864', '34.189345');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2954, 2951, '宕昌县', '宕昌县', 3, '621223', '104.393385', '34.047261');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2955, 2951, '武都区', '武都区', 3, '621202', '104.921861', '33.400685');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2956, 2951, '徽县', '徽县', 3, '621227', '106.087156', '33.769927');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2957, 2951, '文县', '文县', 3, '621222', '104.6835', '32.944031');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2958, 2951, '西和县', '西和县', 3, '621225', '105.298756', '34.014215');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2959, 2951, '成县', '成县', 3, '621221', '105.742508', '33.750722');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2960, 2951, '康县', '康县', 3, '621224', '105.608609', '33.329212');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2961, 2910, '张掖市', '张掖市', 2, '620700', '100.449858', '38.924766');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2962, 2961, '高台县', '高台县', 3, '620724', '99.819265', '39.378294');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2963, 2961, '肃南裕固族自治县', '肃南裕固族自治县', 3, '620721', '99.615601', '38.836931');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2964, 2961, '山丹县', '山丹县', 3, '620725', '101.088611', '38.7846');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2965, 2961, '民乐县', '民乐县', 3, '620722', '100.812047', '38.430318');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2966, 2961, '甘州区', '甘州区', 3, '620702', '100.415324', '38.944315');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2967, 2961, '临泽县', '临泽县', 3, '620723', '100.164333', '39.15224');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2968, 2910, '临夏回族自治州', '临夏回族自治州', 2, '622900', '103.210386', '35.601792');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2969, 2968, '临夏市', '临夏市', 3, '622901', '103.24222', '35.604682');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2970, 2968, '永靖县', '永靖县', 3, '622923', '103.285853', '35.958306');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2971, 2968, '积石山保安族东乡族撒拉族自治县', '积石山保安族东乡族撒拉族自治县', 3, '622927', '102.875939', '35.717697');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2972, 2968, '临夏县', '临夏县', 3, '622921', '103.04068', '35.478726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2973, 2968, '东乡族自治县', '东乡族自治县', 3, '622926', '103.388122', '35.664409');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2974, 2968, '和政县', '和政县', 3, '622925', '103.350996', '35.424602');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2975, 2968, '广河县', '广河县', 3, '622924', '103.575582', '35.488248');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2976, 2968, '康乐县', '康乐县', 3, '622922', '103.708507', '35.370296');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2977, 2910, '甘南藏族自治州', '甘南藏族自治州', 2, '623000', '102.911736', '34.983266');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2978, 2977, '合作市', '合作市', 3, '623001', '102.910305', '35.000228');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2979, 2977, '夏河县', '夏河县', 3, '623027', '102.548303', '35.203857');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2980, 2977, '卓尼县', '卓尼县', 3, '623022', '103.506849', '34.589476');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2981, 2977, '临潭县', '临潭县', 3, '623021', '103.353665', '34.693009');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2982, 2977, '玛曲县', '玛曲县', 3, '623025', '102.072608', '33.998145');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2983, 2977, '舟曲县', '舟曲县', 3, '623023', '104.251543', '33.793695');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2984, 2977, '迭部县', '迭部县', 3, '623024', '103.221735', '34.055888');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2985, 2977, '碌曲县', '碌曲县', 3, '623026', '102.487512', '34.591084');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2986, 2910, '定西市', '定西市', 2, '621100', '104.592342', '35.607947');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2987, 2986, '临洮县', '临洮县', 3, '621124', '103.859446', '35.394993');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2988, 2986, '渭源县', '渭源县', 3, '621123', '104.215092', '35.137028');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2989, 2986, '岷县', '岷县', 3, '621126', '104.036731', '34.43833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2990, 2986, '漳县', '漳县', 3, '621125', '104.471722', '34.84854');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2991, 2986, '安定区', '安定区', 3, '621102', '104.610647', '35.580918');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2992, 2986, '通渭县', '通渭县', 3, '621121', '105.242312', '35.211311');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2993, 2986, '陇西县', '陇西县', 3, '621122', '104.634928', '35.003899');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2994, 2910, '天水市', '天水市', 2, '620500', '105.724828', '34.581514');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2995, 2994, '秦安县', '秦安县', 3, '620522', '105.675799', '34.859094');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2996, 2994, '甘谷县', '甘谷县', 3, '620523', '105.340789', '34.745447');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2997, 2994, '秦州区', '秦州区', 3, '620502', '105.724914', '34.581187');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2998, 2994, '麦积区', '麦积区', 3, '620503', '105.889452', '34.571143');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (2999, 2994, '武山县', '武山县', 3, '620524', '104.89121', '34.72183');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3000, 2994, '清水县', '清水县', 3, '620521', '106.137318', '34.749906');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3001, 2994, '张家川回族自治县', '张家川回族自治县', 3, '620525', '106.20513', '34.988676');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3002, 2910, '庆阳市', '庆阳市', 2, '621000', '107.643433', '35.709459');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3003, 3002, '正宁县', '正宁县', 3, '621025', '108.359964', '35.492158');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3004, 3002, '环县', '环县', 3, '621022', '107.308788', '36.568566');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3005, 3002, '华池县', '华池县', 3, '621023', '107.98972', '36.461474');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3006, 3002, '镇原县', '镇原县', 3, '621027', '107.200888', '35.677705');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3007, 3002, '宁县', '宁县', 3, '621026', '107.913463', '35.509252');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3008, 3002, '庆城县', '庆城县', 3, '621021', '107.881706', '36.016125');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3009, 3002, '合水县', '合水县', 3, '621024', '108.021859', '35.833908');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3010, 3002, '西峰区', '西峰区', 3, '621002', '107.650563', '35.730318');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3011, 2910, '武威市', '武威市', 2, '620600', '102.637821', '37.92898');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3012, 3011, '古浪县', '古浪县', 3, '620622', '102.897542', '37.470882');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3013, 3011, '凉州区', '凉州区', 3, '620602', '102.641959', '37.928217');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3014, 3011, '民勤县', '民勤县', 3, '620621', '103.093671', '38.624293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3015, 3011, '天祝藏族自治县', '天祝藏族自治县', 3, '620623', '103.142416', '36.971978');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3016, 0, '四川省', '四川省', 1, '510000', '104.076452', '30.651696');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3017, 3016, '巴中市', '巴中市', 2, '511900', '106.747548', '31.867853');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3018, 3017, '通江县', '通江县', 3, '511921', '107.245033', '31.911705');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3019, 3017, '平昌县', '平昌县', 3, '511923', '107.103613', '31.560436');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3020, 3017, '南江县', '南江县', 3, '511922', '106.828697', '32.346589');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3021, 3017, '巴州区', '巴州区', 3, '511902', '106.76887', '31.851458');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3022, 3017, '恩阳区', '恩阳区', 3, '511903', '106.654386', '31.787186');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3023, 3016, '南充市', '南充市', 2, '511300', '106.110565', '30.837235');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3024, 3023, '嘉陵区', '嘉陵区', 3, '511304', '106.07208', '30.758831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3025, 3023, '南部县', '南部县', 3, '511321', '106.036349', '31.348255');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3026, 3023, '蓬安县', '蓬安县', 3, '511323', '106.412156', '31.028537');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3027, 3023, '西充县', '西充县', 3, '511325', '105.900894', '30.995546');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3028, 3023, '营山县', '营山县', 3, '511322', '106.565524', '31.077057');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3029, 3023, '仪陇县', '仪陇县', 3, '511324', '106.303082', '31.271693');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3030, 3023, '顺庆区', '顺庆区', 3, '511302', '106.092327', '30.797366');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3031, 3023, '高坪区', '高坪区', 3, '511303', '106.118931', '30.781284');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3032, 3023, '阆中市', '阆中市', 3, '511381', '106.005046', '31.558356');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3033, 3016, '广元市', '广元市', 2, '510800', '105.844004', '32.435774');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3034, 3033, '朝天区', '朝天区', 3, '510812', '105.882848', '32.651352');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3035, 3033, '苍溪县', '苍溪县', 3, '510824', '105.934756', '31.731709');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3036, 3033, '昭化区', '昭化区', 3, '510811', '105.957612', '32.333173');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3037, 3033, '剑阁县', '剑阁县', 3, '510823', '105.524699', '32.288681');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3038, 3033, '旺苍县', '旺苍县', 3, '510821', '106.290124', '32.229074');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3039, 3033, '青川县', '青川县', 3, '510822', '105.238498', '32.575821');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3040, 3033, '利州区', '利州区', 3, '510802', '105.845307', '32.433756');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3041, 3016, '德阳市', '德阳市', 2, '510600', '104.397795', '31.127449');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3042, 3041, '中江县', '中江县', 3, '510623', '104.678601', '31.03327');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3043, 3041, '广汉市', '广汉市', 3, '510681', '104.282204', '30.977264');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3044, 3041, '旌阳区', '旌阳区', 3, '510603', '104.417061', '31.143335');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3045, 3041, '什邡市', '什邡市', 3, '510682', '104.167345', '31.12655');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3046, 3041, '罗江区', '罗江区', 3, '510604', '104.510457', '31.317388');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3047, 3041, '绵竹市', '绵竹市', 3, '510683', '104.220679', '31.339251');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3048, 3016, '眉山市', '眉山市', 2, '511400', '103.848417', '30.077113');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3049, 3048, '洪雅县', '洪雅县', 3, '511423', '103.365035', '29.915828');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3050, 3048, '丹棱县', '丹棱县', 3, '511424', '103.512859', '30.014398');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3051, 3048, '仁寿县', '仁寿县', 3, '511421', '104.133931', '29.995638');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3052, 3048, '彭山区', '彭山区', 3, '511403', '103.872852', '30.193278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3053, 3048, '青神县', '青神县', 3, '511425', '103.846596', '29.831302');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3054, 3048, '东坡区', '东坡区', 3, '511402', '103.831868', '30.041956');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3055, 3016, '绵阳市', '绵阳市', 2, '510700', '104.679127', '31.467673');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3056, 3055, '江油市', '江油市', 3, '510781', '104.74564', '31.778572');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3057, 3055, '梓潼县', '梓潼县', 3, '510725', '105.170746', '31.642635');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3058, 3055, '游仙区', '游仙区', 3, '510704', '104.766136', '31.473788');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3059, 3055, '三台县', '三台县', 3, '510722', '105.093722', '31.095826');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3060, 3055, '盐亭县', '盐亭县', 3, '510723', '105.389453', '31.208362');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3061, 3055, '安州区', '安州区', 3, '510705', '104.567543', '31.534319');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3062, 3055, '平武县', '平武县', 3, '510727', '104.555481', '32.409684');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3063, 3055, '涪城区', '涪城区', 3, '510703', '104.756917', '31.455192');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3064, 3055, '北川羌族自治县', '北川羌族自治县', 3, '510726', '104.468163', '31.617192');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3065, 3016, '成都市', '成都市', 2, '510100', '104.066301', '30.572961');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3066, 3065, '崇州市', '崇州市', 3, '510184', '103.673025', '30.630183');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3067, 3065, '都江堰市', '都江堰市', 3, '510181', '103.647193', '30.988763');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3068, 3065, '青白江区', '青白江区', 3, '510113', '104.251342', '30.8786');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3069, 3065, '大邑县', '大邑县', 3, '510129', '103.51226', '30.573004');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3070, 3065, '简阳市', '简阳市', 3, '510185', '104.547644', '30.410937');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3071, 3065, '彭州市', '彭州市', 3, '510182', '103.957706', '30.990463');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3072, 3065, '蒲江县', '蒲江县', 3, '510131', '103.506478', '30.197558');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3073, 3065, '金堂县', '金堂县', 3, '510121', '104.411871', '30.86203');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3074, 3065, '新津区', '新津区', 3, '510118', '103.810906', '30.410404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3075, 3065, '邛崃市', '邛崃市', 3, '510183', '103.464176', '30.41029');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3076, 3065, '温江区', '温江区', 3, '510115', '103.856423', '30.681956');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3077, 3065, '武侯区', '武侯区', 3, '510107', '104.043246', '30.641849');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3078, 3065, '双流区', '双流区', 3, '510116', '103.92342', '30.574884');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3079, 3065, '新都区', '新都区', 3, '510114', '104.158593', '30.823568');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3080, 3065, '龙泉驿区', '龙泉驿区', 3, '510112', '104.27536', '30.556808');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3081, 3065, '成华区', '成华区', 3, '510108', '104.101452', '30.659966');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3082, 3065, '锦江区', '锦江区', 3, '510104', '104.117262', '30.598726');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3083, 3065, '青羊区', '青羊区', 3, '510105', '104.062415', '30.674583');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3084, 3065, '金牛区', '金牛区', 3, '510106', '104.052236', '30.691359');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3085, 3065, '郫都区', '郫都区', 3, '510117', '103.900486', '30.795113');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3086, 3016, '达州市', '达州市', 2, '511700', '107.46778', '31.209278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3087, 3086, '大竹县', '大竹县', 3, '511724', '107.204702', '30.736222');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3088, 3086, '宣汉县', '宣汉县', 3, '511722', '107.727198', '31.353845');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3089, 3086, '渠县', '渠县', 3, '511725', '106.973114', '30.836504');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3090, 3086, '开江县', '开江县', 3, '511723', '107.868609', '31.082945');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3091, 3086, '万源市', '万源市', 3, '511781', '108.034393', '32.081698');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3092, 3086, '通川区', '通川区', 3, '511702', '107.505053', '31.214665');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3093, 3086, '达川区', '达川区', 3, '511703', '107.511736', '31.196573');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3094, 3016, '广安市', '广安市', 2, '511600', '106.632647', '30.456354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3095, 3094, '邻水县', '邻水县', 3, '511623', '106.930242', '30.334911');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3096, 3094, '武胜县', '武胜县', 3, '511622', '106.295945', '30.349493');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3097, 3094, '广安区', '广安区', 3, '511602', '106.641628', '30.473943');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3098, 3094, '前锋区', '前锋区', 3, '511603', '106.886039', '30.496059');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3099, 3094, '华蓥市', '华蓥市', 3, '511681', '106.783151', '30.390439');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3100, 3094, '岳池县', '岳池县', 3, '511621', '106.440056', '30.538656');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3101, 3016, '资阳市', '资阳市', 2, '512000', '104.627265', '30.129236');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3102, 3101, '乐至县', '乐至县', 3, '512022', '105.019823', '30.275418');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3103, 3101, '雁江区', '雁江区', 3, '512002', '104.676814', '30.107778');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3104, 3101, '安岳县', '安岳县', 3, '512021', '105.35551', '30.103623');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3105, 3016, '乐山市', '乐山市', 2, '511100', '103.766085', '29.552275');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3106, 3105, '夹江县', '夹江县', 3, '511126', '103.571313', '29.738143');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3107, 3105, '沙湾区', '沙湾区', 3, '511111', '103.550118', '29.412404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3108, 3105, '犍为县', '犍为县', 3, '511123', '103.949231', '29.208118');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3109, 3105, '金口河区', '金口河区', 3, '511113', '103.078597', '29.244345');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3110, 3105, '峨边彝族自治县', '峨边彝族自治县', 3, '511132', '103.262048', '29.230426');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3111, 3105, '井研县', '井研县', 3, '511124', '104.06968', '29.65165');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3112, 3105, '五通桥区', '五通桥区', 3, '511112', '103.818024', '29.406837');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3113, 3105, '沐川县', '沐川县', 3, '511129', '103.902691', '28.956394');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3114, 3105, '马边彝族自治县', '马边彝族自治县', 3, '511133', '103.546347', '28.83552');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3115, 3105, '市中区', '市中区', 3, '511102', '103.761329', '29.555374');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3116, 3105, '峨眉山市', '峨眉山市', 3, '511181', '103.484557', '29.601189');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3117, 3016, '内江市', '内江市', 2, '511000', '105.057992', '29.58021');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3118, 3117, '资中县', '资中县', 3, '511025', '104.851874', '29.763419');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3119, 3117, '威远县', '威远县', 3, '511024', '104.669032', '29.527456');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3120, 3117, '东兴区', '东兴区', 3, '511011', '105.076107', '29.593528');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3121, 3117, '隆昌市', '隆昌市', 3, '511083', '105.287507', '29.339408');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3122, 3117, '市中区', '市中区', 3, '511002', '105.06759', '29.587091');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3123, 3016, '遂宁市', '遂宁市', 2, '510900', '105.592602', '30.53268');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3124, 3123, '船山区', '船山区', 3, '510903', '105.568359', '30.526201');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3125, 3123, '大英县', '大英县', 3, '510923', '105.236852', '30.594472');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3126, 3123, '蓬溪县', '蓬溪县', 3, '510921', '105.707498', '30.75763');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3127, 3123, '安居区', '安居区', 3, '510904', '105.45636', '30.355091');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3128, 3123, '射洪市', '射洪市', 3, '510981', '105.388366', '30.871079');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3129, 3016, '自贡市', '自贡市', 2, '510300', '104.779307', '29.33924');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3130, 3129, '沿滩区', '沿滩区', 3, '510311', '104.873826', '29.27208');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3131, 3129, '富顺县', '富顺县', 3, '510322', '104.975193', '29.181779');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3132, 3129, '贡井区', '贡井区', 3, '510303', '104.715294', '29.345481');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3133, 3129, '自流井区', '自流井区', 3, '510302', '104.777182', '29.337295');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3134, 3129, '大安区', '大安区', 3, '510304', '104.773982', '29.36371');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3135, 3129, '荣县', '荣县', 3, '510321', '104.417438', '29.445461');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3136, 3016, '宜宾市', '宜宾市', 2, '511500', '104.642826', '28.752354');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3137, 3136, '珙县', '珙县', 3, '511526', '104.708986', '28.439514');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3138, 3136, '江安县', '江安县', 3, '511523', '105.066982', '28.723797');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3139, 3136, '高县', '高县', 3, '511525', '104.517748', '28.436166');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3140, 3136, '长宁县', '长宁县', 3, '511524', '104.920643', '28.582866');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3141, 3136, '兴文县', '兴文县', 3, '511528', '105.236207', '28.303669');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3142, 3136, '南溪区', '南溪区', 3, '511503', '104.969147', '28.846366');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3143, 3136, '筠连县', '筠连县', 3, '511527', '104.511159', '28.167981');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3144, 3136, '翠屏区', '翠屏区', 3, '511502', '104.619853', '28.766537');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3145, 3136, '屏山县', '屏山县', 3, '511529', '104.346138', '28.82867');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3146, 3136, '叙州区', '叙州区', 3, '511504', '104.533244', '28.690068');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3147, 3016, '攀枝花市', '攀枝花市', 2, '510400', '101.71846', '26.582417');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3148, 3147, '米易县', '米易县', 3, '510421', '102.111073', '26.896372');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3149, 3147, '西区', '西区', 3, '510403', '101.630557', '26.5977');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3150, 3147, '盐边县', '盐边县', 3, '510422', '101.854027', '26.682611');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3151, 3147, '东区', '东区', 3, '510402', '101.704129', '26.546484');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3152, 3147, '仁和区', '仁和区', 3, '510411', '101.738615', '26.497796');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3153, 3016, '凉山彝族自治州', '凉山彝族自治州', 2, '513400', '102.267713', '27.881396');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3154, 3153, '普格县', '普格县', 3, '513428', '102.540901', '27.376413');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3155, 3153, '雷波县', '雷波县', 3, '513437', '103.571705', '28.263202');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3156, 3153, '会理市', '会理市', 3, '513425', '102.244774', '26.655047');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3157, 3153, '美姑县', '美姑县', 3, '513436', '103.132359', '28.328591');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3158, 3153, '冕宁县', '冕宁县', 3, '513433', '102.176622', '28.550145');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3159, 3153, '会东县', '会东县', 3, '513426', '102.577979', '26.634744');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3160, 3153, '木里藏族自治县', '木里藏族自治县', 3, '513422', '101.280216', '27.928736');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3161, 3153, '甘洛县', '甘洛县', 3, '513435', '102.771441', '28.959131');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3162, 3153, '金阳县', '金阳县', 3, '513430', '103.248786', '27.696735');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3163, 3153, '越西县', '越西县', 3, '513434', '102.507467', '28.639874');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3164, 3153, '布拖县', '布拖县', 3, '513429', '102.809157', '27.7121');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3165, 3153, '喜德县', '喜德县', 3, '513432', '102.412451', '28.306429');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3166, 3153, '盐源县', '盐源县', 3, '513423', '101.509038', '27.422593');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3167, 3153, '德昌县', '德昌县', 3, '513424', '102.175661', '27.402832');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3168, 3153, '宁南县', '宁南县', 3, '513427', '102.751587', '27.061431');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3169, 3153, '西昌市', '西昌市', 3, '513401', '102.264166', '27.89441');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3170, 3153, '昭觉县', '昭觉县', 3, '513431', '102.839849', '28.015301');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3171, 3016, '泸州市', '泸州市', 2, '510500', '105.441866', '28.87098');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3172, 3171, '纳溪区', '纳溪区', 3, '510503', '105.371324', '28.772888');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3173, 3171, '古蔺县', '古蔺县', 3, '510525', '105.812694', '28.038763');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3174, 3171, '泸县', '泸县', 3, '510521', '105.381879', '29.1516');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3175, 3171, '龙马潭区', '龙马潭区', 3, '510504', '105.437751', '28.913257');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3176, 3171, '叙永县', '叙永县', 3, '510524', '105.444777', '28.155631');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3177, 3171, '江阳区', '江阳区', 3, '510502', '105.434982', '28.87881');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3178, 3171, '合江县', '合江县', 3, '510522', '105.831011', '28.811278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3179, 3016, '雅安市', '雅安市', 2, '511800', '103.041538', '30.009998');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3180, 3179, '雨城区', '雨城区', 3, '511802', '103.032868', '30.005718');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3181, 3179, '芦山县', '芦山县', 3, '511826', '102.933618', '30.145077');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3182, 3179, '荥经县', '荥经县', 3, '511822', '102.846537', '29.793254');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3183, 3179, '汉源县', '汉源县', 3, '511823', '102.650417', '29.344275');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3184, 3179, '天全县', '天全县', 3, '511825', '102.771745', '30.05728');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3185, 3179, '宝兴县', '宝兴县', 3, '511827', '102.814156', '30.382154');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3186, 3179, '石棉县', '石棉县', 3, '511824', '102.358364', '29.230963');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3187, 3179, '名山区', '名山区', 3, '511803', '103.109238', '30.069837');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3188, 3016, '阿坝藏族羌族自治州', '阿坝藏族羌族自治州', 2, '513200', '102.224504', '31.899427');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3189, 3188, '马尔康市', '马尔康市', 3, '513201', '102.206386', '31.905799');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3190, 3188, '九寨沟县', '九寨沟县', 3, '513225', '104.2426', '33.252008');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3191, 3188, '黑水县', '黑水县', 3, '513228', '102.987592', '32.069268');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3192, 3188, '若尔盖县', '若尔盖县', 3, '513232', '102.96738', '33.578503');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3193, 3188, '红原县', '红原县', 3, '513233', '102.544395', '32.790841');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3194, 3188, '阿坝县', '阿坝县', 3, '513231', '101.706548', '32.902387');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3195, 3188, '金川县', '金川县', 3, '513226', '102.063821', '31.47625');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3196, 3188, '理县', '理县', 3, '513222', '103.163284', '31.435831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3197, 3188, '汶川县', '汶川县', 3, '513221', '103.590185', '31.476875');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3198, 3188, '松潘县', '松潘县', 3, '513224', '103.60428', '32.655685');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3199, 3188, '茂县', '茂县', 3, '513223', '103.85332', '31.681727');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3200, 3188, '壤塘县', '壤塘县', 3, '513230', '100.978526', '32.265796');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3201, 3188, '小金县', '小金县', 3, '513227', '102.362984', '30.995823');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3202, 3016, '甘孜藏族自治州', '甘孜藏族自治州', 2, '513300', '101.96231', '30.04952');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3203, 3202, '德格县', '德格县', 3, '513330', '98.580914', '31.806118');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3204, 3202, '甘孜县', '甘孜县', 3, '513328', '99.991683', '31.622731');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3205, 3202, '石渠县', '石渠县', 3, '513332', '98.102938', '32.978728');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3206, 3202, '道孚县', '道孚县', 3, '513326', '101.125157', '30.979486');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3207, 3202, '巴塘县', '巴塘县', 3, '513335', '99.110555', '30.00533');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3208, 3202, '理塘县', '理塘县', 3, '513334', '100.269145', '29.994228');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3209, 3202, '新龙县', '新龙县', 3, '513329', '100.311569', '30.93917');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3210, 3202, '炉霍县', '炉霍县', 3, '513327', '100.676014', '31.390657');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3211, 3202, '白玉县', '白玉县', 3, '513331', '98.824025', '31.209669');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3212, 3202, '雅江县', '雅江县', 3, '513325', '101.014366', '30.031498');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3213, 3202, '康定市', '康定市', 3, '513301', '101.95687', '29.998544');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3214, 3202, '稻城县', '稻城县', 3, '513337', '100.297369', '29.03791');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3215, 3202, '乡城县', '乡城县', 3, '513336', '99.798116', '28.931081');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3216, 3202, '九龙县', '九龙县', 3, '513324', '101.507294', '29.000347');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3217, 3202, '得荣县', '得荣县', 3, '513338', '99.286366', '28.713085');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3218, 3202, '丹巴县', '丹巴县', 3, '513323', '101.89054', '30.878618');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3219, 3202, '色达县', '色达县', 3, '513333', '100.333011', '32.268541');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3220, 3202, '泸定县', '泸定县', 3, '513322', '102.234814', '29.914103');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3221, 0, '天津市', '天津市', 1, '120000', '117.201509', '39.085318');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3222, 3221, '天津城区', '天津城区', 2, '120100', '117.190182', '39.125596');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3223, 3222, '宝坻区', '宝坻区', 3, '120115', '117.309748', '39.717054');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3224, 3222, '和平区', '和平区', 3, '120101', '117.214713', '39.116884');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3225, 3222, '河北区', '河北区', 3, '120105', '117.196874', '39.148018');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3226, 3222, '蓟州区', '蓟州区', 3, '120119', '117.408432', '40.046544');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3227, 3222, '滨海新区', '滨海新区', 3, '120116', '117.69641', '39.017809');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3228, 3222, '静海区', '静海区', 3, '120118', '116.975474', '38.947772');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3229, 3222, '武清区', '武清区', 3, '120114', '117.04456', '39.384108');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3230, 3222, '南开区', '南开区', 3, '120104', '117.150638', '39.138551');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3231, 3222, '宁河区', '宁河区', 3, '120117', '117.826674', '39.329749');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3232, 3222, '红桥区', '红桥区', 3, '120106', '117.151566', '39.167349');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3233, 3222, '津南区', '津南区', 3, '120112', '117.356683', '38.936971');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3234, 3222, '西青区', '西青区', 3, '120111', '117.008994', '39.141811');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3235, 3222, '河西区', '河西区', 3, '120103', '117.223379', '39.109679');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3236, 3222, '东丽区', '东丽区', 3, '120110', '117.313567', '39.086789');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3237, 3222, '北辰区', '北辰区', 3, '120113', '117.135614', '39.224638');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3238, 3222, '河东区', '河东区', 3, '120102', '117.251584', '39.128294');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3239, 0, '北京市', '北京市', 1, '110000', '116.407387', '39.904179');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3240, 3239, '北京城区', '北京城区', 2, '110100', '116.405285', '39.904989');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3241, 3240, '怀柔区', '怀柔区', 3, '110116', '116.631974', '40.317003');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3242, 3240, '延庆区', '延庆区', 3, '110119', '115.974609', '40.457033');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3243, 3240, '顺义区', '顺义区', 3, '110113', '116.661474', '40.149891');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3244, 3240, '门头沟区', '门头沟区', 3, '110109', '116.101668', '39.940842');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3245, 3240, '平谷区', '平谷区', 3, '110117', '117.121589', '40.140805');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3246, 3240, '朝阳区', '朝阳区', 3, '110105', '116.443136', '39.921444');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3247, 3240, '东城区', '东城区', 3, '110101', '116.416334', '39.928359');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3248, 3240, '大兴区', '大兴区', 3, '110115', '116.341483', '39.726917');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3249, 3240, '通州区', '通州区', 3, '110112', '116.72923', '39.916403');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3250, 3240, '密云区', '密云区', 3, '110118', '116.843351', '40.377058');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3251, 3240, '房山区', '房山区', 3, '110111', '116.143426', '39.748889');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3252, 3240, '西城区', '西城区', 3, '110102', '116.36585', '39.9126');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3253, 3240, '丰台区', '丰台区', 3, '110106', '116.286726', '39.858538');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3254, 3240, '石景山区', '石景山区', 3, '110107', '116.223015', '39.906304');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3255, 3240, '海淀区', '海淀区', 3, '110108', '116.2977', '39.959893');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3256, 3240, '昌平区', '昌平区', 3, '110114', '116.231034', '40.220952');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3257, 0, '江西省', '江西省', 1, '360000', '115.816587', '28.637234');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3258, 3257, '抚州市', '抚州市', 2, '361000', '116.358054', '27.948979');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3259, 3258, '东乡区', '东乡区', 3, '361003', '116.603159', '28.249059');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3260, 3258, '临川区', '临川区', 3, '361002', '116.311932', '27.935098');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3261, 3258, '资溪县', '资溪县', 3, '361028', '117.060332', '27.706088');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3262, 3258, '宜黄县', '宜黄县', 3, '361026', '116.236174', '27.554744');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3263, 3258, '南城县', '南城县', 3, '361021', '116.637228', '27.570031');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3264, 3258, '崇仁县', '崇仁县', 3, '361024', '116.076363', '27.754416');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3265, 3258, '金溪县', '金溪县', 3, '361027', '116.755018', '27.91973');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3266, 3258, '乐安县', '乐安县', 3, '361025', '115.83099', '27.428682');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3267, 3258, '黎川县', '黎川县', 3, '361022', '116.907446', '27.282729');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3268, 3258, '广昌县', '广昌县', 3, '361030', '116.336556', '26.843974');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3269, 3258, '南丰县', '南丰县', 3, '361023', '116.525898', '27.21845');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3270, 3257, '赣州市', '赣州市', 2, '360700', '114.933494', '25.831139');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3271, 3270, '宁都县', '宁都县', 3, '360730', '116.009171', '26.470865');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3272, 3270, '大余县', '大余县', 3, '360723', '114.362306', '25.401968');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3273, 3270, '瑞金市', '瑞金市', 3, '360781', '116.027114', '25.88623');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3274, 3270, '石城县', '石城县', 3, '360735', '116.347611', '26.31491');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3275, 3270, '于都县', '于都县', 3, '360731', '115.415145', '25.952564');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3276, 3270, '兴国县', '兴国县', 3, '360732', '115.363475', '26.338129');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3277, 3270, '寻乌县', '寻乌县', 3, '360734', '115.638534', '24.969513');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3278, 3270, '崇义县', '崇义县', 3, '360725', '114.308135', '25.682278');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3279, 3270, '信丰县', '信丰县', 3, '360722', '114.922485', '25.38676');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3280, 3270, '上犹县', '上犹县', 3, '360724', '114.55177', '25.784754');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3281, 3270, '全南县', '全南县', 3, '360729', '114.530148', '24.742353');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3282, 3270, '南康区', '南康区', 3, '360703', '114.765044', '25.661369');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3283, 3270, '赣县区', '赣县区', 3, '360704', '115.021196', '25.854496');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3284, 3270, '龙南市', '龙南市', 3, '360783', '114.804474', '24.901216');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3285, 3270, '定南县', '定南县', 3, '360728', '115.027908', '24.783372');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3286, 3270, '章贡区', '章贡区', 3, '360702', '114.920426', '25.818247');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3287, 3270, '安远县', '安远县', 3, '360726', '115.393992', '25.136855');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3288, 3270, '会昌县', '会昌县', 3, '360733', '115.809271', '25.58734');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3289, 3257, '九江市', '九江市', 2, '360400', '115.95356', '29.66116');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3290, 3289, '都昌县', '都昌县', 3, '360428', '116.203999', '29.273803');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3291, 3289, '彭泽县', '彭泽县', 3, '360430', '116.563858', '29.877404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3292, 3289, '湖口县', '湖口县', 3, '360429', '116.252206', '29.731194');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3293, 3289, '武宁县', '武宁县', 3, '360423', '115.092649', '29.246785');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3294, 3289, '柴桑区', '柴桑区', 3, '360404', '115.911005', '29.608775');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3295, 3289, '修水县', '修水县', 3, '360424', '114.546536', '29.026166');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3296, 3289, '庐山市', '庐山市', 3, '360483', '116.045118', '29.448225');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3297, 3289, '濂溪区', '濂溪区', 3, '360402', '115.992735', '29.668008');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3298, 3289, '永修县', '永修县', 3, '360425', '115.83207', '29.011392');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3299, 3289, '共青城市', '共青城市', 3, '360482', '115.784269', '29.235082');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3300, 3289, '瑞昌市', '瑞昌市', 3, '360481', '115.681221', '29.676026');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3301, 3289, '德安县', '德安县', 3, '360426', '115.767114', '29.298599');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3302, 3289, '浔阳区', '浔阳区', 3, '360403', '116.001677', '29.70547');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3303, 3257, '景德镇市', '景德镇市', 2, '360200', '117.184892', '29.2744');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3304, 3303, '浮梁县', '浮梁县', 3, '360222', '117.214984', '29.352493');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3305, 3303, '昌江区', '昌江区', 3, '360202', '117.182648', '29.273683');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3306, 3303, '乐平市', '乐平市', 3, '360281', '117.151499', '28.978521');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3307, 3303, '珠山区', '珠山区', 3, '360203', '117.271365', '29.305191');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3308, 3257, '萍乡市', '萍乡市', 2, '360300', '113.887147', '27.658721');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3309, 3308, '安源区', '安源区', 3, '360302', '113.87072', '27.615');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3310, 3308, '芦溪县', '芦溪县', 3, '360323', '114.029351', '27.631273');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3311, 3308, '莲花县', '莲花县', 3, '360321', '113.961589', '27.128498');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3312, 3308, '上栗县', '上栗县', 3, '360322', '113.795294', '27.880221');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3313, 3308, '湘东区', '湘东区', 3, '360313', '113.733047', '27.640075');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3314, 3257, '南昌市', '南昌市', 2, '360100', '115.857972', '28.682976');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3315, 3314, '进贤县', '进贤县', 3, '360124', '116.242468', '28.377627');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3316, 3314, '青云谱区', '青云谱区', 3, '360104', '115.925709', '28.62182');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3317, 3314, '青山湖区', '青山湖区', 3, '360111', '115.962138', '28.682867');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3318, 3314, '东湖区', '东湖区', 3, '360102', '115.903576', '28.698787');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3319, 3314, '安义县', '安义县', 3, '360123', '115.549158', '28.845585');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3320, 3314, '红谷滩区', '红谷滩区', 3, '360113', '115.858127', '28.698188');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3321, 3314, '新建区', '新建区', 3, '360112', '115.815244', '28.693192');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3322, 3314, '西湖区', '西湖区', 3, '360103', '115.876998', '28.657005');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3323, 3314, '南昌县', '南昌县', 3, '360121', '115.93349', '28.557921');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3324, 3257, '宜春市', '宜春市', 2, '360900', '114.416826', '27.816245');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3325, 3324, '上高县', '上高县', 3, '360923', '114.948045', '28.238591');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3326, 3324, '丰城市', '丰城市', 3, '360981', '115.771131', '28.160053');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3327, 3324, '高安市', '高安市', 3, '360983', '115.366863', '28.448054');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3328, 3324, '宜丰县', '宜丰县', 3, '360924', '114.803036', '28.394466');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3329, 3324, '铜鼓县', '铜鼓县', 3, '360926', '114.354623', '28.513291');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3330, 3324, '万载县', '万载县', 3, '360922', '114.445477', '28.106201');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3331, 3324, '袁州区', '袁州区', 3, '360902', '114.42794', '27.796344');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3332, 3324, '樟树市', '樟树市', 3, '360982', '115.546174', '28.054632');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3333, 3324, '靖安县', '靖安县', 3, '360925', '115.362635', '28.861296');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3334, 3324, '奉新县', '奉新县', 3, '360921', '115.400624', '28.688254');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3335, 3257, '新余市', '新余市', 2, '360500', '114.916665', '27.818553');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3336, 3335, '分宜县', '分宜县', 3, '360521', '114.69264', '27.814723');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3337, 3335, '渝水区', '渝水区', 3, '360502', '114.944499', '27.799526');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3338, 3257, '吉安市', '吉安市', 2, '360800', '114.96681', '27.091243');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3339, 3338, '吉安县', '吉安县', 3, '360821', '114.908337', '27.039866');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3340, 3338, '吉州区', '吉州区', 3, '360802', '114.994991', '27.144204');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3341, 3338, '永丰县', '永丰县', 3, '360825', '115.421599', '27.317301');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3342, 3338, '永新县', '永新县', 3, '360830', '114.242425', '26.945157');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3343, 3338, '吉水县', '吉水县', 3, '360822', '115.135963', '27.229697');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3344, 3338, '青原区', '青原区', 3, '360803', '115.014836', '27.082012');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3345, 3338, '万安县', '万安县', 3, '360828', '114.759746', '26.456821');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3346, 3338, '遂川县', '遂川县', 3, '360827', '114.520825', '26.313413');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3347, 3338, '安福县', '安福县', 3, '360829', '114.619818', '27.393286');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3348, 3338, '新干县', '新干县', 3, '360824', '115.386853', '27.740368');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3349, 3338, '峡江县', '峡江县', 3, '360823', '115.316567', '27.5829');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3350, 3338, '井冈山市', '井冈山市', 3, '360881', '114.289563', '26.748132');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3351, 3338, '泰和县', '泰和县', 3, '360826', '114.922987', '26.801687');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3352, 3257, '鹰潭市', '鹰潭市', 2, '360600', '117.039532', '28.272092');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3353, 3352, '贵溪市', '贵溪市', 3, '360681', '117.245178', '28.292397');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3354, 3352, '月湖区', '月湖区', 3, '360602', '117.10247', '28.266999');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3355, 3352, '余江区', '余江区', 3, '360603', '116.854576', '28.199657');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3356, 3257, '上饶市', '上饶市', 2, '361100', '117.943064', '28.45513');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3357, 3356, '弋阳县', '弋阳县', 3, '361126', '117.449346', '28.378039');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3358, 3356, '婺源县', '婺源县', 3, '361130', '117.8618', '29.248081');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3359, 3356, '广丰区', '广丰区', 3, '361103', '118.189729', '28.463697');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3360, 3356, '横峰县', '横峰县', 3, '361125', '117.596433', '28.407116');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3361, 3356, '铅山县', '铅山县', 3, '361124', '117.734742', '28.298415');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3362, 3356, '玉山县', '玉山县', 3, '361123', '118.244736', '28.681936');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3363, 3356, '广信区', '广信区', 3, '361104', '117.907454', '28.448893');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3364, 3356, '信州区', '信州区', 3, '361102', '117.965997', '28.430694');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3365, 3356, '余干县', '余干县', 3, '361127', '116.695787', '28.70283');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3366, 3356, '万年县', '万年县', 3, '361129', '117.058445', '28.694582');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3367, 3356, '鄱阳县', '鄱阳县', 3, '361128', '116.703731', '29.005675');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3368, 3356, '德兴市', '德兴市', 3, '361181', '117.594549', '28.930557');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3369, 0, '吉林省', '吉林省', 1, '220000', '125.325802', '43.896942');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3370, 3369, '白城市', '白城市', 2, '220800', '122.838102', '45.620131');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3371, 3370, '大安市', '大安市', 3, '220882', '124.291032', '45.507004');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3372, 3370, '洮南市', '洮南市', 3, '220881', '122.79845', '45.356849');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3373, 3370, '通榆县', '通榆县', 3, '220822', '123.088093', '44.812912');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3374, 3370, '洮北区', '洮北区', 3, '220802', '122.851105', '45.621545');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3375, 3370, '镇赉县', '镇赉县', 3, '220821', '123.19967', '45.848195');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3376, 3369, '长春市', '长春市', 2, '220100', '125.323643', '43.816996');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3377, 3376, '德惠市', '德惠市', 3, '220183', '125.728552', '44.521788');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3378, 3376, '榆树市', '榆树市', 3, '220182', '126.533126', '44.840263');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3379, 3376, '双阳区', '双阳区', 3, '220112', '125.664583', '43.525367');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3380, 3376, '农安县', '农安县', 3, '220122', '125.184921', '44.432829');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3381, 3376, '宽城区', '宽城区', 3, '220103', '125.326614', '43.943522');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3382, 3376, '九台区', '九台区', 3, '220113', '125.839549', '44.151672');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3383, 3376, '公主岭市', '公主岭市', 3, '220184', '124.79379', '43.495116');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3384, 3376, '朝阳区', '朝阳区', 3, '220104', '125.288168', '43.833845');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3385, 3376, '绿园区', '绿园区', 3, '220106', '125.256214', '43.881047');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3386, 3376, '南关区', '南关区', 3, '220102', '125.350341', '43.86382');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3387, 3376, '二道区', '二道区', 3, '220105', '125.37419', '43.865912');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3388, 3369, '松原市', '松原市', 2, '220700', '124.825321', '45.14191');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3389, 3388, '扶余市', '扶余市', 3, '220781', '126.049534', '44.989057');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3390, 3388, '宁江区', '宁江区', 3, '220702', '124.792839', '45.186486');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3391, 3388, '前郭尔罗斯蒙古族自治县', '前郭尔罗斯蒙古族自治县', 3, '220721', '124.823417', '45.118061');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3392, 3388, '乾安县', '乾安县', 3, '220723', '124.040651', '45.003539');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3393, 3388, '长岭县', '长岭县', 3, '220722', '123.967244', '44.276293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3394, 3369, '吉林市', '吉林市', 2, '220200', '126.549719', '43.838132');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3395, 3394, '丰满区', '丰满区', 3, '220211', '126.561351', '43.821192');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3396, 3394, '桦甸市', '桦甸市', 3, '220282', '126.746245', '42.972272');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3397, 3394, '舒兰市', '舒兰市', 3, '220283', '126.965515', '44.405922');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3398, 3394, '蛟河市', '蛟河市', 3, '220281', '127.344773', '43.72382');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3399, 3394, '龙潭区', '龙潭区', 3, '220203', '126.562131', '43.910743');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3400, 3394, '永吉县', '永吉县', 3, '220221', '126.497899', '43.672198');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3401, 3394, '磐石市', '磐石市', 3, '220284', '126.060328', '42.946608');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3402, 3394, '昌邑区', '昌邑区', 3, '220202', '126.574414', '43.881896');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3403, 3394, '船营区', '船营区', 3, '220204', '126.540909', '43.833806');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3404, 3369, '辽源市', '辽源市', 2, '220400', '125.144676', '42.887961');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3405, 3404, '西安区', '西安区', 3, '220403', '125.149488', '42.927252');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3406, 3404, '东丰县', '东丰县', 3, '220421', '125.53096', '42.677253');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3407, 3404, '东辽县', '东辽县', 3, '220422', '124.991045', '42.925636');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3408, 3404, '龙山区', '龙山区', 3, '220402', '125.13703', '42.902194');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3409, 3369, '通化市', '通化市', 2, '220500', '125.939721', '41.728312');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3410, 3409, '通化县', '通化县', 3, '220521', '125.758927', '41.680135');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3411, 3409, '东昌区', '东昌区', 3, '220502', '125.927187', '41.702872');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3412, 3409, '二道江区', '二道江区', 3, '220503', '126.042546', '41.773989');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3413, 3409, '柳河县', '柳河县', 3, '220524', '125.744654', '42.284594');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3414, 3409, '辉南县', '辉南县', 3, '220523', '126.046006', '42.684706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3415, 3409, '梅河口市', '梅河口市', 3, '220581', '125.711129', '42.539183');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3416, 3409, '集安市', '集安市', 3, '220582', '126.193172', '41.125805');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3417, 3369, '四平市', '四平市', 2, '220300', '124.350599', '43.166764');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3418, 3417, '铁东区', '铁东区', 3, '220303', '124.409852', '43.162664');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3419, 3417, '双辽市', '双辽市', 3, '220382', '123.502398', '43.518301');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3420, 3417, '伊通满族自治县', '伊通满族自治县', 3, '220323', '125.305393', '43.345754');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3421, 3417, '梨树县', '梨树县', 3, '220322', '124.335389', '43.30706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3422, 3417, '铁西区', '铁西区', 3, '220302', '124.345994', '43.146288');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3423, 3369, '延边朝鲜族自治州', '延边朝鲜族自治州', 2, '222400', '129.470605', '42.909426');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3424, 3423, '图们市', '图们市', 3, '222402', '129.843807', '42.968039');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3425, 3423, '珲春市', '珲春市', 3, '222404', '130.365829', '42.862551');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3426, 3423, '和龙市', '和龙市', 3, '222406', '129.010932', '42.546434');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3427, 3423, '汪清县', '汪清县', 3, '222424', '129.785137', '43.317215');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3428, 3423, '安图县', '安图县', 3, '222426', '128.899744', '43.111978');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3429, 3423, '延吉市', '延吉市', 3, '222401', '129.507655', '42.891034');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3430, 3423, '敦化市', '敦化市', 3, '222403', '128.232235', '43.372669');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3431, 3423, '龙井市', '龙井市', 3, '222405', '129.426529', '42.767172');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3432, 3369, '白山市', '白山市', 2, '220600', '126.414274', '41.944132');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3433, 3432, '靖宇县', '靖宇县', 3, '220622', '126.813262', '42.388902');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3434, 3432, '江源区', '江源区', 3, '220605', '126.591178', '42.056747');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3435, 3432, '长白朝鲜族自治县', '长白朝鲜族自治县', 3, '220623', '128.20066', '41.420253');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3436, 3432, '抚松县', '抚松县', 3, '220621', '127.449387', '42.221038');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3437, 3432, '临江市', '临江市', 3, '220681', '126.918086', '41.811979');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3438, 3432, '浑江区', '浑江区', 3, '220602', '126.416093', '41.945409');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3439, 0, '山西省', '山西省', 1, '140000', '112.578781', '37.813948');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3440, 3439, '太原市', '太原市', 2, '140100', '112.549656', '37.870451');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3441, 3440, '娄烦县', '娄烦县', 3, '140123', '111.79715', '38.067569');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3442, 3440, '尖草坪区', '尖草坪区', 3, '140108', '112.486141', '37.940052');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3443, 3440, '杏花岭区', '杏花岭区', 3, '140107', '112.570412', '37.894241');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3444, 3440, '阳曲县', '阳曲县', 3, '140122', '112.67292', '38.058511');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3445, 3440, '清徐县', '清徐县', 3, '140121', '112.359367', '37.608751');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3446, 3440, '古交市', '古交市', 3, '140181', '112.175034', '37.907414');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3447, 3440, '万柏林区', '万柏林区', 3, '140109', '112.515638', '37.859738');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3448, 3440, '晋源区', '晋源区', 3, '140110', '112.477869', '37.715519');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3449, 3440, '小店区', '小店区', 3, '140105', '112.565524', '37.736865');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3450, 3440, '迎泽区', '迎泽区', 3, '140106', '112.563373', '37.863308');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3451, 3439, '阳泉市', '阳泉市', 2, '140300', '113.580426', '37.857094');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3452, 3451, '平定县', '平定县', 3, '140321', '113.629777', '37.804986');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3453, 3451, '郊区', '郊区', 3, '140311', '113.593998', '37.943703');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3454, 3451, '城区', '城区', 3, '140302', '113.600694', '37.847457');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3455, 3451, '盂县', '盂县', 3, '140322', '113.412279', '38.086041');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3456, 3451, '矿区', '矿区', 3, '140303', '113.555279', '37.868494');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3457, 3439, '朔州市', '朔州市', 2, '140600', '112.432906', '39.331734');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3458, 3457, '右玉县', '右玉县', 3, '140623', '112.466926', '39.989198');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3459, 3457, '平鲁区', '平鲁区', 3, '140603', '112.28827', '39.512219');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3460, 3457, '山阴县', '山阴县', 3, '140621', '112.816421', '39.527445');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3461, 3457, '怀仁市', '怀仁市', 3, '140681', '113.133061', '39.820522');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3462, 3457, '朔城区', '朔城区', 3, '140602', '112.432071', '39.320196');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3463, 3457, '应县', '应县', 3, '140622', '113.190952', '39.554471');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3464, 3439, '吕梁市', '吕梁市', 2, '141100', '111.14454', '37.518996');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3465, 3464, '临县', '临县', 3, '141124', '110.992712', '37.951008');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3466, 3464, '离石区', '离石区', 3, '141102', '111.150325', '37.517797');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3467, 3464, '方山县', '方山县', 3, '141128', '111.244309', '37.895017');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3468, 3464, '岚县', '岚县', 3, '141127', '111.672156', '38.279587');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3469, 3464, '中阳县', '中阳县', 3, '141129', '111.178841', '37.357816');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3470, 3464, '交口县', '交口县', 3, '141130', '111.181241', '36.982205');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3471, 3464, '柳林县', '柳林县', 3, '141125', '110.888993', '37.429816');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3472, 3464, '兴县', '兴县', 3, '141123', '111.127486', '38.461818');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3473, 3464, '石楼县', '石楼县', 3, '141126', '110.834712', '36.998461');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3474, 3464, '交城县', '交城县', 3, '141122', '112.155857', '37.55169');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3475, 3464, '文水县', '文水县', 3, '141121', '112.028866', '37.438101');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3476, 3464, '孝义市', '孝义市', 3, '141181', '111.778935', '37.146051');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3477, 3464, '汾阳市', '汾阳市', 3, '141182', '111.770834', '37.261493');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3478, 3439, '大同市', '大同市', 2, '140200', '113.366749', '40.09711');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3479, 3478, '灵丘县', '灵丘县', 3, '140224', '114.234452', '39.442459');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3480, 3478, '浑源县', '浑源县', 3, '140225', '113.69183', '39.706485');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3481, 3478, '广灵县', '广灵县', 3, '140223', '114.282703', '39.760404');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3482, 3478, '阳高县', '阳高县', 3, '140221', '113.748944', '40.361059');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3483, 3478, '新荣区', '新荣区', 3, '140212', '113.139628', '40.256355');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3484, 3478, '云州区', '云州区', 3, '140215', '113.612496', '40.040156');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3485, 3478, '天镇县', '天镇县', 3, '140222', '114.090871', '40.42087');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3486, 3478, '左云县', '左云县', 3, '140226', '112.703008', '40.013442');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3487, 3478, '平城区', '平城区', 3, '140213', '113.298011', '40.075246');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3488, 3478, '云冈区', '云冈区', 3, '140214', '113.149604', '40.005383');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3489, 3439, '晋中市', '晋中市', 2, '140700', '112.752633', '37.688006');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3490, 3489, '和顺县', '和顺县', 3, '140723', '113.570295', '37.329696');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3491, 3489, '昔阳县', '昔阳县', 3, '140724', '113.707151', '37.612577');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3492, 3489, '寿阳县', '寿阳县', 3, '140725', '113.176373', '37.895191');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3493, 3489, '榆社县', '榆社县', 3, '140721', '112.975378', '37.071209');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3494, 3489, '介休市', '介休市', 3, '140781', '111.916451', '37.027538');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3495, 3489, '左权县', '左权县', 3, '140722', '113.379412', '37.082746');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3496, 3489, '灵石县', '灵石县', 3, '140729', '111.778692', '36.848085');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3497, 3489, '榆次区', '榆次区', 3, '140702', '112.707564', '37.698637');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3498, 3489, '太谷区', '太谷区', 3, '140703', '112.551297', '37.421392');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3499, 3489, '祁县', '祁县', 3, '140727', '112.335226', '37.358425');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3500, 3489, '平遥县', '平遥县', 3, '140728', '112.175825', '37.189614');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3501, 3439, '忻州市', '忻州市', 2, '140900', '112.734149', '38.415958');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3502, 3501, '原平市', '原平市', 3, '140981', '112.711025', '38.731412');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3503, 3501, '宁武县', '宁武县', 3, '140925', '112.304734', '39.001498');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3504, 3501, '五台县', '五台县', 3, '140922', '113.255419', '38.728056');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3505, 3501, '五寨县', '五寨县', 3, '140928', '111.846808', '38.91111');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3506, 3501, '偏关县', '偏关县', 3, '140932', '111.508922', '39.436917');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3507, 3501, '代县', '代县', 3, '140923', '112.960102', '39.066831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3508, 3501, '岢岚县', '岢岚县', 3, '140929', '111.572964', '38.703989');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3509, 3501, '忻府区', '忻府区', 3, '140902', '112.746357', '38.403498');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3510, 3501, '定襄县', '定襄县', 3, '140921', '112.957234', '38.471725');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3511, 3501, '静乐县', '静乐县', 3, '140926', '111.939498', '38.359306');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3512, 3501, '繁峙县', '繁峙县', 3, '140924', '113.265464', '39.188835');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3513, 3501, '神池县', '神池县', 3, '140927', '112.210997', '39.091079');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3514, 3501, '保德县', '保德县', 3, '140931', '111.085944', '39.022616');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3515, 3501, '河曲县', '河曲县', 3, '140930', '111.138247', '39.38452');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3516, 3439, '晋城市', '晋城市', 2, '140500', '112.852022', '35.491315');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3517, 3516, '城区', '城区', 3, '140502', '112.853452', '35.50248');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3518, 3516, '泽州县', '泽州县', 3, '140525', '112.922243', '35.507061');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3519, 3516, '沁水县', '沁水县', 3, '140521', '112.186726', '35.690119');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3520, 3516, '阳城县', '阳城县', 3, '140522', '112.414798', '35.486275');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3521, 3516, '陵川县', '陵川县', 3, '140524', '113.280755', '35.775239');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3522, 3516, '高平市', '高平市', 3, '140581', '112.923798', '35.798775');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3523, 3439, '长治市', '长治市', 2, '140400', '113.117394', '36.195142');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3524, 3523, '黎城县', '黎城县', 3, '140426', '113.387025', '36.502258');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3525, 3523, '屯留区', '屯留区', 3, '140405', '112.892301', '36.3162');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3526, 3523, '潞城区', '潞城区', 3, '140406', '113.228897', '36.334597');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3527, 3523, '长子县', '长子县', 3, '140428', '112.877922', '36.122258');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3528, 3523, '平顺县', '平顺县', 3, '140425', '113.435859', '36.20037');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3529, 3523, '襄垣县', '襄垣县', 3, '140423', '113.051298', '36.535629');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3530, 3523, '潞州区', '潞州区', 3, '140403', '113.122725', '36.203305');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3531, 3523, '沁县', '沁县', 3, '140430', '112.699176', '36.756152');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3532, 3523, '武乡县', '武乡县', 3, '140429', '112.86396', '36.837865');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3533, 3523, '壶关县', '壶关县', 3, '140427', '113.206836', '36.115645');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3534, 3523, '沁源县', '沁源县', 3, '140431', '112.337726', '36.499989');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3535, 3523, '上党区', '上党区', 3, '140404', '113.051416', '36.053104');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3536, 3439, '运城市', '运城市', 2, '140800', '111.007051', '35.02667');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3537, 3536, '夏县', '夏县', 3, '140828', '111.219946', '35.140733');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3538, 3536, '盐湖区', '盐湖区', 3, '140802', '110.998135', '35.015549');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3539, 3536, '万荣县', '万荣县', 3, '140822', '110.837957', '35.415805');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3540, 3536, '闻喜县', '闻喜县', 3, '140823', '111.224485', '35.356664');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3541, 3536, '临猗县', '临猗县', 3, '140821', '110.774553', '35.144406');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3542, 3536, '平陆县', '平陆县', 3, '140829', '111.193957', '34.829595');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3543, 3536, '新绛县', '新绛县', 3, '140825', '111.224767', '35.616007');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3544, 3536, '垣曲县', '垣曲县', 3, '140827', '111.670215', '35.298297');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3545, 3536, '稷山县', '稷山县', 3, '140824', '110.983273', '35.604515');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3546, 3536, '河津市', '河津市', 3, '140882', '110.712032', '35.596357');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3547, 3536, '芮城县', '芮城县', 3, '140830', '110.694418', '34.694173');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3548, 3536, '永济市', '永济市', 3, '140881', '110.447771', '34.866499');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3549, 3536, '绛县', '绛县', 3, '140826', '111.568849', '35.491764');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3550, 3439, '临汾市', '临汾市', 2, '141000', '111.51931', '36.088581');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3551, 3550, '古县', '古县', 3, '141025', '111.92031', '36.266767');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3552, 3550, '汾西县', '汾西县', 3, '141034', '111.563993', '36.652833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3553, 3550, '隰县', '隰县', 3, '141031', '110.940752', '36.693345');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3554, 3550, '大宁县', '大宁县', 3, '141030', '110.752914', '36.465126');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3555, 3550, '吉县', '吉县', 3, '141028', '110.680513', '36.096833');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3556, 3550, '安泽县', '安泽县', 3, '141026', '112.250242', '36.147921');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3557, 3550, '永和县', '永和县', 3, '141032', '110.631981', '36.759524');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3558, 3550, '霍州市', '霍州市', 3, '141082', '111.755111', '36.569046');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3559, 3550, '侯马市', '侯马市', 3, '141081', '111.372002', '35.619105');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3560, 3550, '乡宁县', '乡宁县', 3, '141029', '110.846585', '35.970834');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3561, 3550, '蒲县', '蒲县', 3, '141033', '111.096457', '36.41183');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3562, 3550, '洪洞县', '洪洞县', 3, '141024', '111.67571', '36.254087');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3563, 3550, '襄汾县', '襄汾县', 3, '141023', '111.441725', '35.876293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3564, 3550, '翼城县', '翼城县', 3, '141022', '111.719048', '35.739706');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3565, 3550, '浮山县', '浮山县', 3, '141027', '111.848883', '35.968124');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3566, 3550, '尧都区', '尧都区', 3, '141002', '111.578797', '36.082463');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3567, 3550, '曲沃县', '曲沃县', 3, '141021', '111.475783', '35.641883');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3568, 0, '云南省', '云南省', 1, '530000', '102.709372', '25.046432');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3569, 3568, '曲靖市', '曲靖市', 2, '530300', '103.796288', '25.490866');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3570, 3569, '会泽县', '会泽县', 3, '530326', '103.297155', '26.417116');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3571, 3569, '马龙区', '马龙区', 3, '530304', '103.578459', '25.428102');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3572, 3569, '罗平县', '罗平县', 3, '530324', '104.297124', '24.865388');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3573, 3569, '陆良县', '陆良县', 3, '530322', '103.66671', '25.0293');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3574, 3569, '师宗县', '师宗县', 3, '530323', '103.985224', '24.822471');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3575, 3569, '宣威市', '宣威市', 3, '530381', '104.104255', '26.218956');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3576, 3569, '富源县', '富源县', 3, '530325', '104.255082', '25.674217');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3577, 3569, '麒麟区', '麒麟区', 3, '530302', '103.804406', '25.496472');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3578, 3569, '沾益区', '沾益区', 3, '530303', '103.822104', '25.600424');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3579, 3568, '昭通市', '昭通市', 2, '530600', '103.717078', '27.338185');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3580, 3579, '绥江县', '绥江县', 3, '530626', '103.968995', '28.592119');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3581, 3579, '永善县', '永善县', 3, '530625', '103.63756', '28.229018');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3582, 3579, '大关县', '大关县', 3, '530624', '103.891164', '27.748054');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3583, 3579, '威信县', '威信县', 3, '530629', '105.049012', '27.846839');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3584, 3579, '水富市', '水富市', 3, '530681', '104.415964', '28.629951');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3585, 3579, '巧家县', '巧家县', 3, '530622', '102.935343', '26.896904');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3586, 3579, '镇雄县', '镇雄县', 3, '530627', '104.873486', '27.441527');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3587, 3579, '鲁甸县', '鲁甸县', 3, '530621', '103.557969', '27.186668');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3588, 3579, '昭阳区', '昭阳区', 3, '530602', '103.706323', '27.320035');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3589, 3579, '彝良县', '彝良县', 3, '530628', '104.055991', '27.624277');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3590, 3579, '盐津县', '盐津县', 3, '530623', '104.234458', '28.108475');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3591, 3568, '怒江傈僳族自治州', '怒江傈僳族自治州', 2, '533300', '98.8566', '25.817555');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3592, 3591, '贡山独龙族怒族自治县', '贡山独龙族怒族自治县', 3, '533324', '98.666279', '27.740839');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3593, 3591, '兰坪白族普米族自治县', '兰坪白族普米族自治县', 3, '533325', '99.416628', '26.453622');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3594, 3591, '福贡县', '福贡县', 3, '533323', '98.869132', '26.901831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3595, 3591, '泸水市', '泸水市', 3, '533301', '98.857723', '25.822579');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3596, 3568, '红河哈尼族彝族自治州', '红河哈尼族彝族自治州', 2, '532500', '103.374873', '23.363129');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3597, 3596, '弥勒市', '弥勒市', 3, '532504', '103.414817', '24.411774');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3598, 3596, '泸西县', '泸西县', 3, '532527', '103.76615', '24.531981');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3599, 3596, '石屏县', '石屏县', 3, '532525', '102.496138', '23.705707');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3600, 3596, '建水县', '建水县', 3, '532524', '102.826178', '23.635824');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3601, 3596, '开远市', '开远市', 3, '532502', '103.266908', '23.714518');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3602, 3596, '个旧市', '个旧市', 3, '532501', '103.152663', '23.389935');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3603, 3596, '元阳县', '元阳县', 3, '532528', '102.835358', '23.219671');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3604, 3596, '红河县', '红河县', 3, '532529', '102.420566', '23.368946');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3605, 3596, '蒙自市', '蒙自市', 3, '532503', '103.364936', '23.396111');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3606, 3596, '屏边苗族自治县', '屏边苗族自治县', 3, '532523', '103.675458', '22.986733');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3607, 3596, '绿春县', '绿春县', 3, '532531', '102.392655', '22.993654');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3608, 3596, '金平苗族瑶族傣族自治县', '金平苗族瑶族傣族自治县', 3, '532530', '103.227982', '22.769894');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3609, 3596, '河口瑶族自治县', '河口瑶族自治县', 3, '532532', '103.939265', '22.529438');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3610, 3568, '西双版纳傣族自治州', '西双版纳傣族自治州', 2, '532800', '100.797002', '22.009037');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3611, 3610, '景洪市', '景洪市', 3, '532801', '100.799595', '22.011792');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3612, 3610, '勐腊县', '勐腊县', 3, '532823', '101.564635', '21.459233');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3613, 3610, '勐海县', '勐海县', 3, '532822', '100.452444', '21.957323');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3614, 3568, '玉溪市', '玉溪市', 2, '530400', '102.526673', '24.346786');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3615, 3614, '易门县', '易门县', 3, '530425', '102.161947', '24.672156');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3616, 3614, '华宁县', '华宁县', 3, '530424', '102.928914', '24.19322');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3617, 3614, '峨山彝族自治县', '峨山彝族自治县', 3, '530426', '102.405698', '24.168899');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3618, 3614, '红塔区', '红塔区', 3, '530402', '102.540122', '24.341215');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3619, 3614, '江川区', '江川区', 3, '530403', '102.748499', '24.299441');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3620, 3614, '新平彝族傣族自治县', '新平彝族傣族自治县', 3, '530427', '101.990805', '24.070436');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3621, 3614, '通海县', '通海县', 3, '530423', '102.725538', '24.11114');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3622, 3614, '元江哈尼族彝族傣族自治县', '元江哈尼族彝族傣族自治县', 3, '530428', '101.998138', '23.596068');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3623, 3614, '澄江市', '澄江市', 3, '530481', '102.904181', '24.675536');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3624, 3568, '大理白族自治州', '大理白族自治州', 2, '532900', '100.267608', '25.606548');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3625, 3624, '鹤庆县', '鹤庆县', 3, '532932', '100.176331', '26.560122');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3626, 3624, '云龙县', '云龙县', 3, '532929', '99.371021', '25.885733');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3627, 3624, '洱源县', '洱源县', 3, '532930', '99.962294', '26.11337');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3628, 3624, '剑川县', '剑川县', 3, '532931', '99.905041', '26.536889');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3629, 3624, '宾川县', '宾川县', 3, '532924', '100.590274', '25.830491');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3630, 3624, '大理市', '大理市', 3, '532901', '100.301614', '25.678466');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3631, 3624, '弥渡县', '弥渡县', 3, '532925', '100.491038', '25.343778');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3632, 3624, '祥云县', '祥云县', 3, '532923', '100.549961', '25.483727');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3633, 3624, '永平县', '永平县', 3, '532928', '99.54063', '25.464134');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3634, 3624, '漾濞彝族自治县', '漾濞彝族自治县', 3, '532922', '99.958089', '25.669944');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3635, 3624, '巍山彝族回族自治县', '巍山彝族回族自治县', 3, '532927', '100.306977', '25.227065');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3636, 3624, '南涧彝族自治县', '南涧彝族自治县', 3, '532926', '100.510333', '25.032353');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3637, 3568, '迪庆藏族自治州', '迪庆藏族自治州', 2, '533400', '99.70211', '27.819149');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3638, 3637, '香格里拉市', '香格里拉市', 3, '533401', '99.743582', '27.842185');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3639, 3637, '德钦县', '德钦县', 3, '533422', '98.917851', '28.464213');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3640, 3637, '维西傈僳族自治县', '维西傈僳族自治县', 3, '533423', '99.300937', '27.163808');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3641, 3568, '丽江市', '丽江市', 2, '530700', '100.225936', '26.855165');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3642, 3641, '宁蒗彝族自治县', '宁蒗彝族自治县', 3, '530724', '100.851083', '27.282207');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3643, 3641, '永胜县', '永胜县', 3, '530722', '100.750907', '26.684215');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3644, 3641, '玉龙纳西族自治县', '玉龙纳西族自治县', 3, '530721', '100.236967', '26.821494');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3645, 3641, '古城区', '古城区', 3, '530702', '100.22583', '26.876468');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3646, 3641, '华坪县', '华坪县', 3, '530723', '101.265373', '26.629598');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3647, 3568, '文山壮族苗族自治州', '文山壮族苗族自治州', 2, '532600', '104.21567', '23.400983');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3648, 3647, '丘北县', '丘北县', 3, '532626', '104.166713', '24.05064');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3649, 3647, '广南县', '广南县', 3, '532627', '105.055075', '24.046378');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3650, 3647, '文山市', '文山市', 3, '532601', '104.233237', '23.38683');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3651, 3647, '砚山县', '砚山县', 3, '532622', '104.336905', '23.605075');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3652, 3647, '西畴县', '西畴县', 3, '532623', '104.671802', '23.437707');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3653, 3647, '麻栗坡县', '麻栗坡县', 3, '532624', '104.702732', '23.125837');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3654, 3647, '马关县', '马关县', 3, '532625', '104.394524', '23.013108');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3655, 3647, '富宁县', '富宁县', 3, '532628', '105.630921', '23.625072');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3656, 3568, '保山市', '保山市', 2, '530500', '99.161489', '25.112018');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3657, 3656, '腾冲市', '腾冲市', 3, '530581', '98.490276', '25.020283');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3658, 3656, '隆阳区', '隆阳区', 3, '530502', '99.165638', '25.121137');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3659, 3656, '昌宁县', '昌宁县', 3, '530524', '99.605105', '24.827739');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3660, 3656, '龙陵县', '龙陵县', 3, '530523', '98.68941', '24.586703');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3661, 3656, '施甸县', '施甸县', 3, '530521', '99.18919', '24.723084');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3662, 3568, '普洱市', '普洱市', 2, '530800', '100.966011', '22.825229');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3663, 3662, '景东彝族自治县', '景东彝族自治县', 3, '530823', '100.833877', '24.446731');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3664, 3662, '镇沅彝族哈尼族拉祜族自治县', '镇沅彝族哈尼族拉祜族自治县', 3, '530825', '101.108733', '24.00445');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3665, 3662, '宁洱哈尼族彝族自治县', '宁洱哈尼族彝族自治县', 3, '530821', '101.045743', '23.048809');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3666, 3662, '景谷傣族彝族自治县', '景谷傣族彝族自治县', 3, '530824', '100.702807', '23.496987');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3667, 3662, '墨江哈尼族自治县', '墨江哈尼族自治县', 3, '530822', '101.692461', '23.431894');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3668, 3662, '澜沧拉祜族自治县', '澜沧拉祜族自治县', 3, '530828', '99.932045', '22.555799');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3669, 3662, '思茅区', '思茅区', 3, '530802', '100.977069', '22.786769');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3670, 3662, '孟连傣族拉祜族佤族自治县', '孟连傣族拉祜族佤族自治县', 3, '530827', '99.584225', '22.329053');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3671, 3662, '西盟佤族自治县', '西盟佤族自治县', 3, '530829', '99.59016', '22.644237');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3672, 3662, '江城哈尼族彝族自治县', '江城哈尼族彝族自治县', 3, '530826', '101.862344', '22.585858');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3673, 3568, '楚雄彝族自治州', '楚雄彝族自治州', 2, '532300', '101.528304', '25.045678');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3674, 3673, '元谋县', '元谋县', 3, '532328', '101.87434', '25.704499');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3675, 3673, '大姚县', '大姚县', 3, '532326', '101.336576', '25.729551');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3676, 3673, '牟定县', '牟定县', 3, '532323', '101.546898', '25.312939');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3677, 3673, '姚安县', '姚安县', 3, '532325', '101.241632', '25.504287');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3678, 3673, '禄丰市', '禄丰市', 3, '532331', '102.079082', '25.151061');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3679, 3673, '南华县', '南华县', 3, '532324', '101.283236', '25.200163');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3680, 3673, '楚雄市', '楚雄市', 3, '532301', '101.546242', '25.032945');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3681, 3673, '双柏县', '双柏县', 3, '532322', '101.642369', '24.688814');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3682, 3673, '武定县', '武定县', 3, '532329', '102.403949', '25.530731');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3683, 3673, '永仁县', '永仁县', 3, '532327', '101.666795', '26.049522');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3684, 3568, '临沧市', '临沧市', 2, '530900', '100.088837', '23.884175');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3685, 3684, '凤庆县', '凤庆县', 3, '530921', '99.92873', '24.580559');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3686, 3684, '云县', '云县', 3, '530922', '100.1303', '24.444461');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3687, 3684, '永德县', '永德县', 3, '530923', '99.258702', '24.018463');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3688, 3684, '镇康县', '镇康县', 3, '530924', '98.825389', '23.762886');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3689, 3684, '临翔区', '临翔区', 3, '530902', '100.082073', '23.895298');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3690, 3684, '耿马傣族佤族自治县', '耿马傣族佤族自治县', 3, '530926', '99.397126', '23.538092');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3691, 3684, '双江拉祜族佤族布朗族傣族自治县', '双江拉祜族佤族布朗族傣族自治县', 3, '530925', '99.828225', '23.472719');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3692, 3684, '沧源佤族自治县', '沧源佤族自治县', 3, '530927', '99.245894', '23.146758');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3693, 3568, '昆明市', '昆明市', 2, '530100', '102.833669', '24.88149');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3694, 3693, '寻甸回族彝族自治县', '寻甸回族彝族自治县', 3, '530129', '103.256559', '25.558163');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3695, 3693, '东川区', '东川区', 3, '530113', '103.187825', '26.082997');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3696, 3693, '宜良县', '宜良县', 3, '530125', '103.141674', '24.91983');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3697, 3693, '五华区', '五华区', 3, '530102', '102.707262', '25.043635');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3698, 3693, '西山区', '西山区', 3, '530112', '102.664426', '25.038039');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3699, 3693, '石林彝族自治县', '石林彝族自治县', 3, '530126', '103.290536', '24.771761');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3700, 3693, '晋宁区', '晋宁区', 3, '530115', '102.595325', '24.669077');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3701, 3693, '安宁市', '安宁市', 3, '530181', '102.47865', '24.919831');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3702, 3693, '富民县', '富民县', 3, '530124', '102.497722', '25.221924');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3703, 3693, '禄劝彝族苗族自治县', '禄劝彝族苗族自治县', 3, '530128', '102.471993', '25.551768');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3704, 3693, '嵩明县', '嵩明县', 3, '530127', '103.043384', '25.327273');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3705, 3693, '盘龙区', '盘龙区', 3, '530103', '102.751643', '25.116512');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3706, 3693, '官渡区', '官渡区', 3, '530111', '102.748888', '24.950285');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3707, 3693, '呈贡区', '呈贡区', 3, '530114', '102.822104', '24.885738');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3708, 3568, '德宏傣族景颇族自治州', '德宏傣族景颇族自治州', 2, '533100', '98.585621', '24.433146');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3709, 3708, '盈江县', '盈江县', 3, '533123', '97.943474', '24.691325');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3710, 3708, '梁河县', '梁河县', 3, '533122', '98.296584', '24.804275');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3711, 3708, '陇川县', '陇川县', 3, '533124', '97.793359', '24.182347');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3712, 3708, '芒市', '芒市', 3, '533103', '98.58809', '24.433766');
INSERT IGNORE INTO `kuerp_area` (`id`, `pid`, `shortname`, `name`, `level`, `adcode`,`lng`, `lat`) VALUES (3713, 3708, '瑞丽市', '瑞丽市', 3, '533102', '97.855423', '24.018377');

CREATE TABLE IF NOT EXISTS `kuerp_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `account_coding` varchar(100) NOT NULL COMMENT '账户编号',
  `account_name` varchar(100) NOT NULL COMMENT '账户名称',
  `balance` double(15,4) DEFAULT NULL COMMENT '当前余额',
  `start_account_balance` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '期初余额',
  `start_account_time` varchar(20) NOT NULL DEFAULT '' COMMENT '建账日期',
  `account_type_id` enum('1','2') NOT NULL DEFAULT '1' COMMENT '账户类型:1=现金,2=银行存款',
  `is_default` enum('0','1') DEFAULT '0' COMMENT '默认:0=否,1=是',
  `status` enum('0','1') DEFAULT '1' COMMENT '状态:0=关闭,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='账户表';

INSERT IGNORE INTO `kuerp_accounts` (`id`, `admin_id`, `account_coding`, `account_name`, `balance`, `start_account_balance`, `start_account_time`, `account_type_id`, `is_default`,`status`, `createtime`, `updatetime`, `deletetime`) VALUES
(1,NULL,'ZH001','默认账户',0.0000,0.0000,'1644373418','1','1','1',1644373442,1644388538,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_accounts_copewith` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `suppliers_id` int(11) NOT NULL DEFAULT '0' COMMENT '供应商',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `purchase_code` varchar(100) NOT NULL DEFAULT '' COMMENT '单据编号',
  `business_type` enum('0','1','2','3','4','5','6','7','8','9','10') DEFAULT NULL COMMENT '业务类型:0=期初余额,1=预收冲应收,2=预付冲应付,3=应收冲应付,4=应收转应收,5=应付转应付,6=普通采购,7=采购退回,8=其他支出,9=付款,10=核销',
  `receivable` double(15,4) DEFAULT '0.0000' COMMENT '增加应付款',
  `advance` double(15,4) DEFAULT '0.0000' COMMENT '增加预付款',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `sale_money` double(15,4) DEFAULT NULL COMMENT '购货金额',
  `receivable_money` double(15,4) DEFAULT NULL COMMENT '应付金额',
  `amount` double(15,4) DEFAULT NULL COMMENT '优惠金额',
  `cost` double(15,4) DEFAULT NULL,
  `real_money` double(15,4) DEFAULT NULL COMMENT '实际付款金额',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='应付账款明细表';


CREATE TABLE IF NOT EXISTS `kuerp_accounts_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `account_coding` varchar(100) NOT NULL COMMENT '账户编号',
  `account_name` varchar(100) NOT NULL COMMENT '账户名称',
  `balance` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '当前余额',
  `income` double(15,4) DEFAULT NULL COMMENT '收入',
  `expenditure` double(15,4) DEFAULT NULL COMMENT '支出',
  `pay_time` bigint(16) DEFAULT NULL COMMENT '日期',
  `bill_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `business_type` tinyint(3) DEFAULT NULL COMMENT '业务类型:1=期初余额,2=普通采购,3=购货付款,4=购货退货,5=销货,6=销货退货,7=收款单,8=付款单,9=其他收入单,10=其他支出单,11=转账单转入,12=转账单转出',
  `supplyer_code` varchar(50) DEFAULT NULL COMMENT '往来单位',
  `customers_id` int(11) DEFAULT NULL COMMENT '往来单位',
  `payment` int(11) DEFAULT NULL COMMENT '收/付款人',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='账户记录表';


CREATE TABLE IF NOT EXISTS `kuerp_accounts_receivable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `customers_id` int(11) NOT NULL DEFAULT '0' COMMENT '客户',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `purchase_code` varchar(100) NOT NULL DEFAULT '' COMMENT '单据编号',
  `business_type` enum('0','1','2','3','4','5','6','7','8','9','10') DEFAULT NULL COMMENT '业务类型:0=期初余额,1=预收冲应收,2=预付冲应付,3=应收冲应付,4=应收转应收,5=应付转应付,6=普通销售,7=销售退回,8=其他收入,9=收款,10=核销',
  `receivable` double(15,4) DEFAULT NULL COMMENT '增加应收款',
  `advance` double(15,4) DEFAULT NULL COMMENT '增加预收款',
  `staff_member_id` int(11) DEFAULT NULL COMMENT '销售人员',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `sale_money` double(15,4) DEFAULT NULL COMMENT '销售金额',
  `receivable_money` double(15,4) DEFAULT NULL COMMENT '应收金额',
  `amount` double(15,4) DEFAULT NULL COMMENT '优惠金额',
  `cost` double(15,4) DEFAULT NULL COMMENT '客户承担费用',
  `real_money` double(15,4) DEFAULT NULL COMMENT '实际收款金额',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='应收账款明细表';


CREATE TABLE IF NOT EXISTS `kuerp_accounts_transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '转账日期',
  `money` double(15,4) DEFAULT NULL COMMENT '合计金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=全部付款,2=部分付款',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='资金转账单';

CREATE TABLE IF NOT EXISTS `kuerp_accounts_transfer_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_id` int(11) DEFAULT NULL COMMENT '转账单ID',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '转账日期',
  `accounts_out_id` int(11) DEFAULT NULL COMMENT '转出账户',
  `accounts_enter_id` int(11) DEFAULT NULL COMMENT '转入账户',
  `settlementtype_id` int(11) DEFAULT NULL COMMENT '结算方式',
  `settlement_number` varchar(50) DEFAULT NULL COMMENT '结算号',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='转账单详情';

CREATE TABLE IF NOT EXISTS `kuerp_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `nickname` varchar(100) DEFAULT NULL COMMENT '地址简称',
  `connect_name` varchar(100) NOT NULL COMMENT '联系人',
  `connect_phone` varchar(20) NOT NULL COMMENT '联系电话',
  `connect_mobile` varchar(11) NOT NULL COMMENT '手机号码',
  `province` int(11) NOT NULL DEFAULT '0' COMMENT '省',
  `city` int(11) NOT NULL DEFAULT '0' COMMENT '市',
  `area` int(11) NOT NULL DEFAULT '0' COMMENT '区',
  `detail_address` varchar(255) NOT NULL COMMENT '详细地址',
  `post_code` varchar(50) NOT NULL COMMENT '邮政编码',
  `is_default` enum('0','1') NOT NULL DEFAULT '0' COMMENT '默认地址:0=否,1=是',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='发货地址表';

CREATE TABLE IF NOT EXISTS `kuerp_adjustment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1') DEFAULT NULL COMMENT '业务类型:1=成本调整',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='成本调整单';

CREATE TABLE IF NOT EXISTS `kuerp_adjustment_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品ID',
  `goods_unit` int(11) DEFAULT '0' COMMENT '单位',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='成本调整单详情';


CREATE TABLE IF NOT EXISTS `kuerp_allocation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='调拨单';

CREATE TABLE IF NOT EXISTS `kuerp_allocation_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `allocation_id` varchar(50) NOT NULL DEFAULT '' COMMENT '调拨单ID',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品ID',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_out` int(11) DEFAULT NULL COMMENT '调出仓库',
  `stores_enter` int(11) DEFAULT NULL COMMENT '调入仓库',
  `number` int(11) DEFAULT NULL COMMENT '数量',
  `goods_batch_id` int(11) DEFAULT NULL COMMENT '批次ID',
  `goods_batch_name` varchar(255) DEFAULT NULL COMMENT '批次',
  `goods_serial_id` text COMMENT '序列号',
  `remarks` varchar(255) DEFAULT NULL COMMENT '分录备注',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `goods_note` varchar(255) DEFAULT NULL COMMENT '商品备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='调拨单详情';

CREATE TABLE IF NOT EXISTS `kuerp_assemble` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类型:1=组装单',
  `money` double(15,4) DEFAULT NULL COMMENT '费用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='组装单';

CREATE TABLE IF NOT EXISTS `kuerp_assemble_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') NOT NULL DEFAULT '1' COMMENT '类型:1=组装单',
  `type` enum('1','2') NOT NULL DEFAULT '2' COMMENT '类型:1=组合件,2=子件',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(50) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) NOT NULL DEFAULT '0' COMMENT '商品单位',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `period` text COMMENT '序列号',
  `basic_number` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_cost` double DEFAULT '0' COMMENT '单位成本',
  `cost_money` double DEFAULT '0' COMMENT '成本',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `batch_id` int(11) DEFAULT NULL COMMENT '批次ID',
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '过期时间',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='组装单详情';

CREATE TABLE IF NOT EXISTS `kuerp_assemble_info_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') NOT NULL DEFAULT '1' COMMENT '类型:1=组装单',
  `type` enum('1','2') NOT NULL DEFAULT '2' COMMENT '类型:1=组合件,2=子件',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(50) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) NOT NULL DEFAULT '0' COMMENT '商品单位',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `period` text COMMENT '序列号',
  `basic_number` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_cost` double DEFAULT '0' COMMENT '单位成本',
  `cost_money` double DEFAULT '0' COMMENT '成本',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `batch_id` int(11) DEFAULT NULL COMMENT '批次ID',
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '过期时间',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='组装单详情模板';

CREATE TABLE IF NOT EXISTS `kuerp_assemble_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `temp_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模板名称',
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类型:1=组装单',
  `money` double(15,4) DEFAULT NULL COMMENT '费用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='组装单模板';


CREATE TABLE IF NOT EXISTS `kuerp_attr_combination` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attr_name` varchar(255) DEFAULT NULL,
  `attr_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '属性组合ID(从小到大)',
  `attr_code` varchar(30) NOT NULL DEFAULT '' COMMENT '属性编号',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='属性组合';

CREATE TABLE IF NOT EXISTS `kuerp_attribute` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT '属性名称',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='属性';


CREATE TABLE IF NOT EXISTS `kuerp_aux_combination` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) unsigned DEFAULT NULL,
  `attr_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '属性组合ID(从小到大)',
  `attr_code` varchar(30) NOT NULL DEFAULT '' COMMENT '属性编号',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='辅助属性组合';

CREATE TABLE IF NOT EXISTS `kuerp_auxiliary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `name` varchar(120) NOT NULL DEFAULT '' COMMENT '属性名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '上级',
  `path` varchar(255) DEFAULT NULL COMMENT 'path',
  `weigh` int(11) DEFAULT NULL,
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品辅助属性';


CREATE TABLE IF NOT EXISTS `kuerp_collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `business_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=预收单,2=收款单',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `money` double(15,4) DEFAULT NULL COMMENT '收款合计',
  `write_off` double(15,4) DEFAULT NULL COMMENT '核销金额',
  `discount` double(15,4) DEFAULT NULL COMMENT '整单折扣',
  `advance` double(15,4) DEFAULT NULL COMMENT '预收款',
  `staff_member_id` int(11) unsigned DEFAULT NULL COMMENT '收款人',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `examine_status` enum('0','1') NOT NULL DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='收款单';

CREATE TABLE IF NOT EXISTS `kuerp_collection_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `collection_id` int(11) NOT NULL DEFAULT '0' COMMENT '收款单ID',
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `accounts_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结算账户',
  `money` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '收款金额',
  `settlementtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结算方式',
  `number` varchar(50) DEFAULT '' COMMENT '结算号',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='收款账户信息';

CREATE TABLE IF NOT EXISTS `kuerp_collection_sale` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `collection_id` int(11) NOT NULL DEFAULT '0' COMMENT '收款单ID',
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `purchase_number` varchar(50) NOT NULL DEFAULT '' COMMENT '原单编号',
  `business_type` enum('1','2','3','4','5','6') NOT NULL DEFAULT '1' COMMENT '业务类别:1=预收单,2=预付单,3=应收,4=应付,5=期初应收/付款,6=期初预收/付款',
  `times` int(11) NOT NULL DEFAULT '0' COMMENT '单据日期',
  `money` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '单据金额',
  `write_off` double(15,4) DEFAULT NULL COMMENT '已核销金额',
  `write_off_money` double(15,4) DEFAULT NULL COMMENT '未核销金额',
  `write_off_price` double(15,4) DEFAULT '0.0000' COMMENT '本次核销金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '单据备注',
  `old_money` double(15,4) DEFAULT NULL,
  `old_status` tinyint(3) DEFAULT NULL,
  `old_status_i` tinyint(3) DEFAULT NULL,
  `business_name` varchar(255) DEFAULT NULL COMMENT '单据名称',
  `source_id` int(11) NOT NULL DEFAULT '0' COMMENT '源单ID',
  `type` enum('1','2','3','4') DEFAULT NULL COMMENT '类型:1=购货/销货,2=退货,3=期初,4=核销',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='收款单单据信息';



CREATE TABLE IF NOT EXISTS `kuerp_cost` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2','3','4') DEFAULT NULL COMMENT '业务类型:1=采购,2=销售,3=采购退回,4=销售退回',
  `suppliers_id` int(11) DEFAULT NULL COMMENT '供应商',
  `suppliers_ids` int(11) DEFAULT NULL COMMENT '源单往来单位',
  `expend_type_id` int(11) DEFAULT NULL COMMENT '支出类别',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `income_type_id` int(11) DEFAULT NULL COMMENT '收入类别',
  `purchase_number` varchar(50) DEFAULT NULL COMMENT '源单号',
  `purchase_times` int(11) DEFAULT NULL COMMENT '源单日期',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `pay_money` double(15,4) DEFAULT NULL COMMENT '未付金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=全部付款,2=部分付款',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='采购销售费用清单';

CREATE TABLE IF NOT EXISTS `kuerp_customer_goodscoding` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `customers_id` int(11) NOT NULL DEFAULT '0' COMMENT '客户',
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '关联商品',
  `unit_id` int(11) DEFAULT NULL COMMENT '单位',
  `customer_code` varchar(50) NOT NULL DEFAULT '' COMMENT '客户物料编码',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='客户物料编码';

CREATE TABLE IF NOT EXISTS `kuerp_customerlevel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '等级名称',
  `status` enum('0','1') NOT NULL DEFAULT '0' COMMENT '状态:0=禁用,1=正常',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='客户等级';

INSERT IGNORE INTO `kuerp_customerlevel` (`id`, `admin_id`, `name`, `status`) VALUES
(1,1,'零售客户','1'),
(2,1,'批发客户','1'),
(3,1,'VIP客户','1'),
(4,1,'折扣等级一','1'),
(5,1,'折扣等级二','1');

CREATE TABLE IF NOT EXISTS `kuerp_customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `customer_code` varchar(50) DEFAULT NULL COMMENT '客户编号',
  `customertype_id` int(2) NOT NULL DEFAULT '0' COMMENT '客户类别',
  `customerlevel_id` int(2) NOT NULL DEFAULT '1' COMMENT '客户等级',
  `customer_name` varchar(150) NOT NULL DEFAULT '' COMMENT '客户名称',
  `saler` varchar(100) NOT NULL DEFAULT '' COMMENT '销售人员',
  `connet_name` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人',
  `customer_mobile` varchar(11) NOT NULL DEFAULT '' COMMENT '客户手机',
  `customer_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '客户座机',
  `qq_wx_email` varchar(100) NOT NULL DEFAULT '' COMMENT 'QQ/微信/Email',
  `need_receive_account` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '应收款余额',
  `receive_account` double(15,4) DEFAULT NULL COMMENT '期初应收款',
  `opening_prepayment` double(15,4) DEFAULT NULL COMMENT '期初预收款',
  `identification` varchar(100) DEFAULT NULL COMMENT '纳税人识别号',
  `getgoods_address` varchar(255) NOT NULL DEFAULT '' COMMENT '收货地址',
  `note` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `deposit_bank` varchar(255) DEFAULT NULL COMMENT '开户银行',
  `bank_number` varchar(255) DEFAULT NULL COMMENT '银行卡号',
  `staff_member_id` int(11) DEFAULT NULL COMMENT '销售人员',
  `account_time` bigint(16) unsigned DEFAULT NULL COMMENT '余额日期',
  `third_id` int(11) DEFAULT 0 COMMENT '三方ID',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='客户表';

INSERT IGNORE INTO `kuerp_customers` (`id`, `admin_id`, `customer_code`, `customertype_id`, `customerlevel_id`, `customer_name`, `saler`, `connet_name`, `customer_mobile`, `customer_phone`, `qq_wx_email`, `need_receive_account`, `receive_account`, `opening_prepayment`, `identification`, `getgoods_address`, `note`, `deposit_bank`, `bank_number`, `staff_member_id`, `account_time`, `createtime`, `updatetime`) VALUES
(1,NULL,'KH001',1,1,'默认客户','','默认客户','13888888888','','',0.0000,0.0000,0.0000,'','联系地址','默认客户','','',1,1644336000,1644336000,1644336000);


CREATE TABLE IF NOT EXISTS `kuerp_customers_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `customers_code` varchar(30) NOT NULL DEFAULT '' COMMENT '客户编号',
  `sid` int(11) unsigned DEFAULT NULL COMMENT '客户ID',
  `first_connect_name` varchar(100) NOT NULL DEFAULT '' COMMENT '联系人名称',
  `first_connect_mobile` varchar(11) NOT NULL COMMENT '手机',
  `first_connect_phone` varchar(20) NOT NULL COMMENT '座机',
  `qq_wx_email` varchar(120) NOT NULL COMMENT 'QQ/微信/Email',
  `connect_address` varchar(255) NOT NULL COMMENT '联系地址',
  `is_first` tinyint(3) DEFAULT '0' COMMENT '首要联系人:0=否,1=是',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='客户联系人';

INSERT IGNORE INTO `kuerp_customers_user` (`id`, `admin_id`, `customers_code`, `sid`, `first_connect_name`, `first_connect_mobile`, `first_connect_phone`, `qq_wx_email`, `connect_address`, `is_first`, `status`, `createtime`, `updatetime`, `deletetime`) VALUES
(1,NULL,'KH001',1,'默认客户','13888888888','','','联系地址',1,'1',1644388513,1644388513,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_customertype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `type_name` varchar(100) NOT NULL COMMENT '分类名称',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '上级分类id',
  `path` varchar(255) DEFAULT NULL,
  `type_image` varchar(255) DEFAULT NULL COMMENT '分类图',
  `status` enum('0','1') NOT NULL DEFAULT '0' COMMENT '状态:0=禁用,1=正常',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='客户分类表';

INSERT IGNORE INTO `kuerp_customertype` (`id`, `admin_id`, `type_name`, `pid`, `path`, `type_image`, `status`) VALUES
(1,NULL,'客户默认分类',0,',0,','/assets/img/qrcode.png','1');


CREATE TABLE IF NOT EXISTS `kuerp_expend_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `name` varchar(120) NOT NULL DEFAULT '' COMMENT '名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '上级分类id',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `path` varchar(255) DEFAULT NULL,
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='支出类别表';

INSERT IGNORE INTO `kuerp_expend_type` (`id`, `admin_id`, `name`, `image`, `pid`, `status`, `path`, `createtime`, `updatetime`) VALUES
(1,NULL,'购货','/assets/img/qrcode.png',0,'1',',0,',1644373337,1644373337);


CREATE TABLE IF NOT EXISTS `kuerp_expenditure` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类型:1=其他支出,2=其他',
  `suppliers_id` int(11) DEFAULT NULL COMMENT '供应商',
  `accounts_id` int(11) DEFAULT NULL COMMENT '账户',
  `cost_id` int(11) DEFAULT NULL COMMENT '采购销售ID',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `pay_money` double(15,4) DEFAULT NULL COMMENT '已付金额',
  `arrears` double(15,4) DEFAULT NULL COMMENT '本次欠款',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=全部付款,2=部分付款',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='其他支出单';

CREATE TABLE IF NOT EXISTS `kuerp_expenditure_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_id` int(11) DEFAULT NULL COMMENT '收入单ID',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类型:1=其他收入',
  `suppliers_id` int(11) DEFAULT NULL COMMENT '供应商',
  `expend_type_id` int(11) DEFAULT NULL COMMENT '支出类别',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `cost_id` int(11) DEFAULT NULL,
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='其他支出单详情';

CREATE TABLE IF NOT EXISTS `kuerp_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) unsigned DEFAULT NULL,
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `goods_barcode` varchar(50) DEFAULT '' COMMENT '商品条码',
  `goods_specification_id` varchar(50) NOT NULL DEFAULT '' COMMENT '规格型号',
  `goods_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品类别',
  `manager_warehouse_id` int(11) NOT NULL DEFAULT '0' COMMENT '首选仓库',
  `unit_id` int(11) NOT NULL DEFAULT '0' COMMENT '计量单位',
  `more_unit` enum('1','2') NOT NULL DEFAULT '2' COMMENT '多计量单位:1=是,2=否',
  `more_unit_id` int(11) DEFAULT NULL COMMENT '多单位ID',
  `market_sell_price` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '零售价',
  `wholesale_price` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '批发价',
  `vip_price` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'vip会员价',
  `discount` double(15,4) unsigned DEFAULT '0.0000' COMMENT '折扣率1',
  `discount2` double(15,4) unsigned DEFAULT '0.0000' COMMENT '折扣率2',
  `purchase` double(15,4) unsigned DEFAULT '0.0000' COMMENT '预计采购价',
  `goods_image` varchar(255) NOT NULL DEFAULT '' COMMENT '商品主图',
  `goods_images` text COMMENT '商品图集',
  `content` text COMMENT '商品详情',
  `inventory` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '总库存',
  `more_attribute` enum('0','1') DEFAULT '0' COMMENT '多属性:0=否,1=是',
  `attribute_id` varchar(30) DEFAULT '' COMMENT '商品属性条码',
  `note` varchar(255) NOT NULL COMMENT '备注',
  `is_offten` enum('0','1') NOT NULL DEFAULT '0' COMMENT '是否常用:0=否,1=是',
  `stock_warning` enum('0','1') DEFAULT '0' COMMENT '库存预警:0=否,1=是',
  `min_stock` int(11) DEFAULT '0' COMMENT '最低库存',
  `max_stock` int(11) DEFAULT '0' COMMENT '最高库存',
  `branch` enum('0','1') DEFAULT '0' COMMENT '分仓预警:0=否,1=是',
  `warehousing` int(11) DEFAULT NULL COMMENT '首选入库单位',
  `warehouse` int(11) DEFAULT NULL COMMENT '首选出库单位',
  `period` double(15,4) DEFAULT '0.0000' COMMENT '期初数量',
  `unit_cost` double(15,4) DEFAULT '0.0000' COMMENT '单位成本',
  `price` double(15,4) DEFAULT '0.0000' COMMENT '期初总价',
  `period_status` enum('0','1') DEFAULT '0' COMMENT '期初设置',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=下架,1=上架',
  `is_edit` enum('0','1') DEFAULT '1' COMMENT '允许修改:0=否,1=是',
  `auxiliary` tinyint(3) DEFAULT NULL COMMENT '设置商品辅助属性',
  `auxiliary_type` varchar(255) DEFAULT NULL COMMENT '辅助属性',
  `auxiliary_type_c` varchar(255) DEFAULT NULL COMMENT '辅助属性2',
  `batch` tinyint(3) DEFAULT NULL COMMENT '启用批次保质期管理',
  `shelf_life` int(11) DEFAULT NULL COMMENT '保质期天数',
  `early_warning` int(11) DEFAULT NULL COMMENT '预警天数',
  `serial` tinyint(3) DEFAULT NULL COMMENT '启用序列号',
  `tag` set('hot','sale') DEFAULT 'sale' COMMENT '标签',
  `sale_number` double(15,4) DEFAULT '0.0000' COMMENT '销量',
  `order_status` enum('0','1') NULL DEFAULT '1' COMMENT '订货通显示状态:0=否,1=是',
  `promotion` enum('0','1') NULL DEFAULT '0' COMMENT '是否促销:0=否,1=是',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

INSERT IGNORE INTO `kuerp_goods` (`id`,`admin_id`,`goods_code`,`goods_name`,`goods_barcode`,`goods_specification_id`,`goods_type_id`,`manager_warehouse_id`,`unit_id`,`more_unit`,`more_unit_id`,`market_sell_price`,`wholesale_price`,`vip_price`,`discount`,`discount2`,`purchase`,`goods_image`,`goods_images`,`inventory`,`more_attribute`,`attribute_id`,`note`,`is_offten`,`stock_warning`,`min_stock`,`max_stock`,`branch`,`warehousing`,`warehouse`,`period`,`unit_cost`,`price`,`period_status`,`status`,`is_edit`,`auxiliary`,`auxiliary_type`,`auxiliary_type_c`,`batch`,`shelf_life`,`early_warning`,`serial`,`createtime`,`updatetime`,`deletetime`) VALUES
(1,NULL,'SP001','默认商品','10001','默认',1,1,1,'2',NULL,100.0000,80.0000,75.0000,80.0000,70.0000,50.0000,'/assets/img/qrcode.png','',0,'0','','','1','0',0,0,'0',NULL,NULL,0.0000,0.0000,0.0000,'0','1','1',0,NULL,NULL,0,NULL,NULL,0,1644388607,1644388607,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_goods_attr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `goods_barcode` varchar(50) DEFAULT '' COMMENT '商品条码',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `attribute_id` int(11) DEFAULT NULL COMMENT '属性组合ID',
  `attr_code` varchar(30) DEFAULT NULL COMMENT '属性编号',
  `barcode` varchar(30) DEFAULT NULL COMMENT '属性条码',
  `unit` int(11) NOT NULL DEFAULT '0' COMMENT '计量单位',
  `market_sell_price` double(15,4) unsigned DEFAULT NULL COMMENT '零售价',
  `wholesale_price` double(15,4) unsigned DEFAULT NULL COMMENT '批发价',
  `vip_price` double(15,4) unsigned DEFAULT NULL COMMENT 'vip会员价',
  `discount` double(15,4) unsigned DEFAULT NULL COMMENT '折扣率1',
  `discount2` double(15,4) unsigned DEFAULT NULL COMMENT '折扣率2',
  `purchase` double(15,4) unsigned DEFAULT NULL COMMENT '预计采购价',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品属性价格表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_batch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `attribute_id` int(11) DEFAULT '0' COMMENT '属性组合ID',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库ID',
  `batch_name` varchar(255) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) unsigned DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) unsigned DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '有效期至',
  `address` varchar(255) DEFAULT NULL COMMENT '产地',
  `registration` varchar(255) DEFAULT NULL COMMENT '注册证号',
  `production` varchar(255) DEFAULT NULL COMMENT '生产许可证',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品批次表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_batch_exchange_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `attribute_id` varchar(30) DEFAULT NULL COMMENT '属性组合ID',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库ID',
  `stock` double(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '库存',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=关闭,1=正常',
  `number` float(15,4) unsigned DEFAULT '0.0000' COMMENT '期初数量',
  `batch_name` varchar(255) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) unsigned DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) unsigned DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '有效期至',
  `purchase_id` int(11) DEFAULT NULL COMMENT '购货单号',
  `purchase_info_id` int(11) DEFAULT NULL COMMENT '购货单详情ID',
  `type` tinyint(3) DEFAULT '0' COMMENT '类型:1=期初,2=购货',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品退货批次详情表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_batch_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `attribute_id` int(11) DEFAULT '0' COMMENT '属性组合ID',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库ID',
  `stock` double(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '库存',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=关闭,1=正常',
  `number` float(15,4) unsigned DEFAULT '0.0000' COMMENT '期初数量',
  `batch_name` varchar(255) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) unsigned DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) unsigned DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '有效期至',
  `purchase_id` int(11) DEFAULT NULL COMMENT '购货单号',
  `purchase_info_id` int(11) DEFAULT NULL COMMENT '购货单详情ID',
  `assemble_id` int(11) DEFAULT NULL COMMENT '组合单ID',
  `split_id` int(11) DEFAULT NULL COMMENT '拆卸单ID',
  `type` tinyint(3) DEFAULT '0' COMMENT '类型:1=期初,2=购货,3=盘盈,4=其他入库,5=组合单,6=拆卸单',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品批次详情表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_batch_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `unit_price` double(15,4) DEFAULT '0.0000' COMMENT '商品单价',
  `tax_included` double(15,4) DEFAULT '0.0000' COMMENT '含税单价',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '金额',
  `tax_money` double(15,4) DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库ID',
  `batch_id` int(11) DEFAULT NULL COMMENT '批次ID',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `business_type` enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','16') DEFAULT NULL COMMENT '业务类型:1=期初余额,2=普通采购,3=采购退回,4=普通销售,5=销售退回,6=调拨单,7=盘盈,8=其他入库,9=盘亏,10=其他出库,11=组合单,12=组合单,13=拆卸单,14=拆卸单,16=生产',
  `customer_id` int(11) DEFAULT NULL COMMENT '客户/供应商',
  `sale_id` int(11) DEFAULT NULL COMMENT '销售人员',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `order_id` int(11) DEFAULT NULL COMMENT '来源关联ID',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='批次跟踪表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_batch_sale_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `attribute_id` varchar(30) DEFAULT NULL COMMENT '属性组合ID',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库ID',
  `stock` double(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '库存',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=关闭,1=正常',
  `number` float(15,4) unsigned DEFAULT '0.0000' COMMENT '期初数量',
  `batch_name` varchar(255) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) unsigned DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) unsigned DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '有效期至',
  `purchase_id` int(11) DEFAULT NULL COMMENT '购货单号',
  `purchase_info_id` int(11) DEFAULT NULL COMMENT '购货单详情ID',
  `type` tinyint(3) DEFAULT '0' COMMENT '类型:1=期初,2=购货',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品销售批次详情表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_batch_salee_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `attribute_id` varchar(30) DEFAULT NULL COMMENT '属性组合ID',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库ID',
  `stock` double(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '库存',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=关闭,1=正常',
  `number` float(15,4) unsigned DEFAULT '0.0000' COMMENT '期初数量',
  `batch_name` varchar(255) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) unsigned DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) unsigned DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '有效期至',
  `purchase_id` int(11) DEFAULT NULL COMMENT '购货单号',
  `purchase_info_id` int(11) DEFAULT NULL COMMENT '购货单详情ID',
  `type` tinyint(3) DEFAULT '0' COMMENT '类型:1=期初,2=购货',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品退货批次详情表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_batch_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `attribute_id` int(11) DEFAULT '0' COMMENT '属性组合ID',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库ID',
  `stock` double(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '库存',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=关闭,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品批次库存表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_exchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('0','1','2') DEFAULT '0' COMMENT '类型:0=退货单,1=购货订单退货,2=购货单退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `supplyer_code` varchar(30) DEFAULT NULL COMMENT '供应商编号',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '购货订单号',
  `purchase_id` varchar(50) DEFAULT NULL COMMENT '购货单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `preferential_rate` double(15,4) DEFAULT '0.0000' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `tax_money` double(15,4) DEFAULT NULL,
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=全部付款,2=部分付款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `retreat_status` enum('0','1','2') DEFAULT NULL COMMENT '退款状态:0=未退款,1=全部退款,2=部分退款',
  `retreat_number` double(15,4) DEFAULT '0.0000' COMMENT '退货数量',
  `retreat_money` double(15,4) DEFAULT '0.0000' COMMENT '退款金额',
  `note` varchar(255) DEFAULT NULL COMMENT '备注',
  `arrears` double(15,4) DEFAULT '0.0000' COMMENT '本次欠款',
  `all_arrears` double(15,4) DEFAULT '0.0000' COMMENT '总欠款',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `cost_data` text COMMENT '采购销售费用',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='购货退货单';

CREATE TABLE IF NOT EXISTS `kuerp_goods_exchange_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('0','1','2') DEFAULT NULL COMMENT '类型:1=购货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `supplyer_code` varchar(30) DEFAULT NULL COMMENT '供应商编号',
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_note` varchar(255) DEFAULT NULL COMMENT '商品备注',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `default_unit` int(11) DEFAULT NULL COMMENT '基本单位',
  `basic_nmber` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_price` double(15,4) DEFAULT '0.0000' COMMENT '购货单价',
  `tax_included` double(15,4) DEFAULT NULL COMMENT '含税单价',
  `discount` float(5,2) DEFAULT '0.00' COMMENT '折扣率',
  `dis_money` double(15,4) DEFAULT '0.0000' COMMENT '折扣额',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT NULL COMMENT '税率',
  `tax_money` double(15,4) DEFAULT NULL COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '购货订单号',
  `purchase_id` varchar(50) DEFAULT NULL COMMENT '购货单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `purchase_info_id` int(11) DEFAULT NULL COMMENT '购货单详情ID',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=部分付款,2=全部付款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `retreat_status` tinyint(3) DEFAULT '0' COMMENT '退款状态:0=未退款,1=全部退款,2=部分退款',
  `retreat_number` double(15,4) DEFAULT '0.0000' COMMENT '退货数量',
  `retreat_money` double(15,4) DEFAULT '0.0000' COMMENT '退款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `batch_id` int(11) DEFAULT NULL,
  `batch_name` varchar(100) DEFAULT NULL,
  `manufacture` int(11) DEFAULT NULL,
  `guarantee` int(11) DEFAULT NULL,
  `validity` int(11) DEFAULT NULL,
  `period` text COMMENT '序列号',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='退货明细';

CREATE TABLE IF NOT EXISTS `kuerp_goods_excpur` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exchange_id` int(11) DEFAULT '0',
  `purchase_id` int(11) DEFAULT NULL,
  `type` enum('0','1','2') DEFAULT '0' COMMENT '单据类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='退单关联';

CREATE TABLE IF NOT EXISTS `kuerp_goods_excpur_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exchange_id` int(11) DEFAULT '0',
  `purchase_id` int(11) DEFAULT NULL,
  `type` enum('0','1','2') DEFAULT NULL COMMENT '类型:1=购货订单,2=购货单',
  `number` float(11,2) DEFAULT '0.00',
  `money` float(11,2) DEFAULT '0.00' COMMENT '退款金额',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT '0.0000' COMMENT '税率',
  `tax_money` double(15,4) DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `status` enum('0','1') DEFAULT '0' COMMENT '是否审核',
  `times` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='退单关联';

CREATE TABLE IF NOT EXISTS `kuerp_goods_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_id` int(11) DEFAULT NULL COMMENT '单据ID',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','17') NOT NULL DEFAULT '1' COMMENT '业务类型:1=期初余额,2=普通采购,3=采购退回,4=普通销售,5=销售退回,6=调拨单,7=成本调整,8=盘盈,9=其他入库,10=盘亏,11=其他出库,12=组装单,13组装单,14=拆卸单,15=拆卸单,17=生产',
  `customer_id` int(11) DEFAULT NULL COMMENT '往来单位',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `attribute_id` int(11) DEFAULT NULL COMMENT '属性组合ID',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `stores_id` int(11) DEFAULT '0' COMMENT '仓库ID',
  `enter_number` double(15,4) DEFAULT NULL COMMENT '入库数量',
  `enter_basics` double(15,4) DEFAULT NULL COMMENT '基本单位数量',
  `enter_unit` double(15,4) DEFAULT NULL COMMENT '单位成本',
  `enter_cost` double(15,4) DEFAULT NULL COMMENT '成本',
  `out_number` double(15,4) DEFAULT NULL COMMENT '出库数量',
  `out_basics` double(15,4) DEFAULT NULL COMMENT '基本单位数量',
  `out_unit` double(15,4) DEFAULT NULL COMMENT '单位成本',
  `out_cost` double(15,4) DEFAULT NULL COMMENT '成本',
  `balance_basics` double(15,4) DEFAULT NULL COMMENT '基本单位数量',
  `balance_unit` double(15,4) DEFAULT NULL COMMENT '单位成本',
  `balance_cost` double(15,4) DEFAULT NULL COMMENT '成本',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品收发明细表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_period` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `attribute_id` int(11) DEFAULT NULL COMMENT '属性组合ID',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库ID',
  `stock` double(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '库存',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=关仓,1=正常',
  `period` double(15,4) unsigned DEFAULT '0.0000' COMMENT '期初数量',
  `unit_cost` double(15,4) unsigned DEFAULT '0.0000' COMMENT '单位成本',
  `price` double(15,4) unsigned DEFAULT '0.0000' COMMENT '期初总价',
  `stock_warning` enum('0','1') DEFAULT '0' COMMENT '库存预警:0=否,1=是',
  `min_stock` double(15,4) DEFAULT '0.0000' COMMENT '最低库存',
  `max_stock` double(15,4) DEFAULT '0.0000' COMMENT '最高库存',
  `address` varchar(255) DEFAULT NULL COMMENT '产地',
  `registration` varchar(100) DEFAULT NULL COMMENT '注册证号',
  `production` varchar(100) DEFAULT NULL COMMENT '生产许可证',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品期初表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `goods_barcode` varchar(50) DEFAULT '' COMMENT '商品条码',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `unit` int(11) NOT NULL DEFAULT '0' COMMENT '计量单位',
  `market_sell_price` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '零售价',
  `wholesale_price` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '批发价',
  `vip_price` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'vip会员价',
  `discount` double(15,4) unsigned DEFAULT '0.0000' COMMENT '折扣率1',
  `discount2` double(15,4) unsigned DEFAULT '0.0000' COMMENT '折扣率2',
  `purchase` double(15,4) unsigned DEFAULT '0.0000' COMMENT '预计采购价',
  `is_default` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否主单位:0=否,1=是',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品价格表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_purchase` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=购货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `supplyer_code` varchar(30) DEFAULT NULL COMMENT '供应商编号',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `all_money` float(11,2) DEFAULT '0.00' COMMENT '购货金额',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '购货订单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `tax_money` double(15,4) DEFAULT NULL COMMENT '税额',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=全部付款,2=部分付款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `note` varchar(255) DEFAULT NULL COMMENT '备注',
  `arrears` double(15,4) DEFAULT '0.0000' COMMENT '本次欠款',
  `all_arrears` double(15,4) DEFAULT '0.0000' COMMENT '总欠款',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `cost_data` text COMMENT '采购费用',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `purchase_code` (`purchase_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='购货单';

CREATE TABLE IF NOT EXISTS `kuerp_goods_purchase_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=购货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `supplyer_code` varchar(30) DEFAULT NULL COMMENT '供应商编号',
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_note` varchar(255) DEFAULT NULL COMMENT '商品备注',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `default_unit` int(11) DEFAULT NULL COMMENT '基本单位',
  `basic_nmber` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_price` double(15,4) DEFAULT '0.0000' COMMENT '购货单价',
  `tax_included` double(15,4) DEFAULT NULL COMMENT '含税单价',
  `discount` float(5,2) DEFAULT '0.00' COMMENT '折扣率',
  `dis_money` double(15,4) DEFAULT '0.0000' COMMENT '折扣额',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT NULL COMMENT '税率',
  `tax_money` double(15,4) DEFAULT NULL COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '购货订单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=部分付款,2=全部付款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `order_info_id` varchar(255) DEFAULT NULL COMMENT '购货订单详情ID',
  `batch_id` int(11) DEFAULT NULL,
  `batch_name` varchar(100) DEFAULT NULL,
  `manufacture` int(11) DEFAULT NULL,
  `guarantee` int(11) DEFAULT NULL,
  `validity` int(11) DEFAULT NULL,
  `period` text COMMENT '序列号',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `purchase_code` (`purchase_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品采购明细';

CREATE TABLE IF NOT EXISTS `kuerp_goods_purchase_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=购货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `supplyer_code` varchar(30) DEFAULT NULL COMMENT '供应商编号',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `purchase_id` varchar(50) DEFAULT NULL COMMENT '购货单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `preferential_rate` double(15,4) DEFAULT '0.0000' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `tax_money` double(15,4) unsigned DEFAULT NULL COMMENT '税额',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `status` enum('0','1','2','3') DEFAULT '0' COMMENT '状态:0=未入库,1=全部入库,2=部分入库,3=已取消',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `store_number` double(15,4) DEFAULT '0.0000' COMMENT '入库数量',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `note` varchar(255) DEFAULT NULL COMMENT '备注',
  `arrears` double(15,4) DEFAULT '0.0000' COMMENT '本次欠款',
  `all_arrears` double(15,4) DEFAULT '0.0000' COMMENT '总欠款',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `purchase_code` (`purchase_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='购货订单';

CREATE TABLE IF NOT EXISTS `kuerp_goods_purchase_order_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=购货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `supplyer_code` varchar(30) DEFAULT NULL COMMENT '供应商编号',
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_note` varchar(255) DEFAULT NULL COMMENT '商品备注',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `purchase_number` double(15,4) DEFAULT '0.0000' COMMENT '可生成购货单数量',
  `default_unit` int(11) DEFAULT NULL COMMENT '基本单位',
  `basic_nmber` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_price` double(15,4) DEFAULT '0.0000' COMMENT '购货单价',
  `tax_included` double(15,4) DEFAULT NULL COMMENT '含税单价',
  `discount` double(15,4) DEFAULT '0.0000' COMMENT '折扣率',
  `dis_money` double(15,4) DEFAULT '0.0000' COMMENT '折扣额',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `tax_rate` double(15,4) unsigned DEFAULT '0.0000' COMMENT '税率',
  `tax_money` double(15,4) unsigned DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_id` varchar(50) DEFAULT NULL COMMENT '购货单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `preferential_rate` double(15,4) DEFAULT '0.0000' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `status` enum('0','1','2','3') DEFAULT '0' COMMENT '状态:0=未入库,1=全部入库,2=部分入库,3=已取消',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `library_number` double(15,4) DEFAULT '0.0000' COMMENT '未入库数量',
  `library_money` double(15,4) DEFAULT '0.0000' COMMENT '未入库金额',
  `library_time` bigint(16) DEFAULT NULL COMMENT '最后入库时间',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `purchase_code` (`purchase_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='购货订单详情';

CREATE TABLE IF NOT EXISTS `kuerp_goods_purchase_summary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=购货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `supplyer_code` varchar(30) DEFAULT NULL COMMENT '供应商编号',
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_note` varchar(255) DEFAULT NULL COMMENT '商品备注',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.00' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.00' COMMENT '数量',
  `default_unit` int(11) DEFAULT NULL COMMENT '基本单位',
  `basic_nmber` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_price` float(11,2) DEFAULT '0.00' COMMENT '购货单价',
  `tax_included` double(15,4) DEFAULT NULL COMMENT '含税单价',
  `discount` float(5,2) DEFAULT '0.00' COMMENT '折扣率',
  `dis_money` double(15,4) DEFAULT '0.00' COMMENT '折扣额',
  `all_money` double(15,4) DEFAULT '0.00' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT NULL COMMENT '税率',
  `tax_money` double(15,4) DEFAULT NULL COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '购货订单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '购货单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.00' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.00' COMMENT '优惠后金额',
  `purchase_money` double(15,4) DEFAULT '0.00' COMMENT '采购费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=部分付款,2=全部付款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.00' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `order_info_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `batch_name` varchar(100) DEFAULT NULL,
  `manufacture` int(11) DEFAULT NULL,
  `guarantee` int(11) DEFAULT NULL,
  `validity` int(11) DEFAULT NULL,
  `period` text COMMENT '序列号',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='采购汇总表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_purord` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT '0',
  `purchase_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订单关联';

CREATE TABLE IF NOT EXISTS `kuerp_goods_purord_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT '0',
  `purchase_id` int(11) DEFAULT NULL COMMENT '购货明细ID',
  `type` enum('0','1','2') DEFAULT NULL COMMENT '类型:1=购货订单,2=购货单',
  `number` float(11,2) DEFAULT '0.00' COMMENT '数量',
  `money` float(11,2) DEFAULT '0.00' COMMENT '已付款金额',
  `all_money` float(11,2) DEFAULT '0.00' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT '0.0000' COMMENT '税率',
  `tax_money` double(15,4) DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `status` enum('0','1') DEFAULT '0',
  `times` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订单关联';

CREATE TABLE IF NOT EXISTS `kuerp_goods_saleexc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exchange_id` int(11) DEFAULT '0',
  `purchase_id` int(11) DEFAULT NULL,
  `type` enum('0','1','2') DEFAULT '0' COMMENT '单据类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='退单关联';

CREATE TABLE IF NOT EXISTS `kuerp_goods_saleexc_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exchange_id` int(11) DEFAULT '0',
  `purchase_id` int(11) DEFAULT NULL,
  `type` enum('0','1','2') DEFAULT NULL COMMENT '类型:1=销货订单,2=销货单',
  `number` float(11,2) DEFAULT '0.00',
  `money` float(11,2) DEFAULT '0.00' COMMENT '退款金额',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT '0.0000' COMMENT '税率',
  `tax_money` double(15,4) DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `status` enum('0','1') DEFAULT '0' COMMENT '是否审核',
  `times` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='退单关联';

CREATE TABLE IF NOT EXISTS `kuerp_goods_saleord` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT '0',
  `purchase_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销售订单关联';

CREATE TABLE IF NOT EXISTS `kuerp_goods_saleord_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT '0',
  `purchase_id` int(11) DEFAULT NULL COMMENT '销货明细ID',
  `number` float(11,2) DEFAULT '0.00' COMMENT '数量',
  `money` float(11,2) DEFAULT '0.00' COMMENT '已收款金额',
  `all_money` float(11,2) DEFAULT '0.00' COMMENT '销货金额',
  `tax_rate` double(15,4) DEFAULT '0.0000' COMMENT '税率',
  `tax_money` double(15,4) DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `status` enum('0','1') DEFAULT '0',
  `times` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销售订单关联';

CREATE TABLE IF NOT EXISTS `kuerp_goods_sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `order_code` varchar(50) DEFAULT NULL COMMENT '零售编号',
  `order_time` bigint(16) DEFAULT NULL COMMENT '零售时间',
  `order_type` enum('1','2') DEFAULT '1' COMMENT '单据类型:1=销货单,2=零售单',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=销货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `receiving_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `sale_user` int(11) DEFAULT NULL COMMENT '销售员',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `all_money` float(15,4) DEFAULT '0.0000' COMMENT '销货金额',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '购货订单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `tax_money` double(15,4) DEFAULT NULL COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `customers_money` double(15,4) DEFAULT '0.0000' COMMENT '客户承担费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '收款状态:0=未收款,1=全部收款,2=部分收款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `note` varchar(255) DEFAULT NULL COMMENT '备注',
  `arrears` double(15,4) DEFAULT '0.0000' COMMENT '本次欠款',
  `all_arrears` double(15,4) DEFAULT '0.0000' COMMENT '总欠款',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `cost_data` text COMMENT '采购销售费用',
  `third_id` int(11) DEFAULT 0 COMMENT '三方ID',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `purchase_code` (`purchase_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销货单';

CREATE TABLE IF NOT EXISTS `kuerp_goods_sales_exchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `order_code` varchar(50) DEFAULT NULL COMMENT '零售编号',
  `order_time` bigint(16) DEFAULT NULL COMMENT '零售时间',
  `order_type` enum('1','2') DEFAULT '1' COMMENT '单据类型:1=销货单,2=零售单',
  `purchase_type` enum('0','1','2') DEFAULT '0' COMMENT '类型:0=退货,1=销货订单退货,2=销货单退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `receiving_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `sale_user` int(11) DEFAULT NULL COMMENT '销售员',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '购货订单号',
  `purchase_id` varchar(50) DEFAULT NULL COMMENT '购货单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `tax_money` double(15,4) DEFAULT NULL COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `customers_money` double(15,4) DEFAULT '0.0000' COMMENT '客户承担费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '收款状态:0=未收款,1=全部收款,2=部分收款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `retreat_status` enum('0','1','2') DEFAULT NULL COMMENT '退款状态:0=未退款,1=全部退款,2=部分退款',
  `retreat_number` double(15,4) DEFAULT '0.0000' COMMENT '退货数量',
  `retreat_money` double(15,4) DEFAULT '0.0000' COMMENT '退款金额',
  `note` varchar(255) DEFAULT NULL COMMENT '备注',
  `arrears` double(15,4) DEFAULT '0.0000' COMMENT '本次欠款',
  `all_arrears` double(15,4) DEFAULT '0.0000' COMMENT '总欠款',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `cost_data` text COMMENT '采购销售费用',
  `third_id` int(11) DEFAULT 0 COMMENT '三方ID',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销货退货单';

CREATE TABLE IF NOT EXISTS `kuerp_goods_sales_exchange_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('0','1','2') DEFAULT NULL COMMENT '类型:1=销货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `receiving_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `sale_user` int(11) DEFAULT NULL COMMENT '销售员',
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_note` varchar(255) DEFAULT NULL COMMENT '商品备注',
  `goods_attr` int(11) DEFAULT NULL COMMENT '属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `default_unit` int(11) DEFAULT NULL COMMENT '基本单位',
  `basic_nmber` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_price` double(15,4) DEFAULT '0.0000' COMMENT '购货单价',
  `cost_price` double(15,4) DEFAULT NULL COMMENT '成本价',
  `tax_included` double(15,4) DEFAULT '0.0000' COMMENT '含税单价',
  `discount` float(5,2) DEFAULT '0.00' COMMENT '折扣率',
  `dis_money` double(15,4) DEFAULT '0.0000' COMMENT '折扣额',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT '0.0000' COMMENT '税率',
  `tax_money` double(15,4) DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '购货订单号',
  `purchase_id` varchar(50) DEFAULT NULL COMMENT '购货单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `purchase_info_id` int(11) DEFAULT NULL COMMENT '购货单详情ID',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` float(11,2) DEFAULT '0.00' COMMENT '优惠额',
  `real_money` float(11,2) DEFAULT '0.00' COMMENT '优惠后金额',
  `purchase_money` float(11,2) DEFAULT '0.00' COMMENT '采购费用',
  `customers_money` float(11,2) DEFAULT '0.00' COMMENT '客户承担费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '收款状态:0=未收款,1=全部收款,2=部分收款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` float(11,2) DEFAULT '0.00' COMMENT '已付款金额',
  `retreat_status` float(11,2) DEFAULT '0.00' COMMENT '退款状态:0=未退款,1=全部退款,2=部分退款',
  `retreat_number` float(11,2) DEFAULT '0.00' COMMENT '退货数量',
  `retreat_money` float(11,2) DEFAULT '0.00' COMMENT '退款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `batch_id` int(11) DEFAULT NULL,
  `batch_name` varchar(100) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '过期时间',
  `period` text COMMENT '序列号',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='退货明细';

CREATE TABLE IF NOT EXISTS `kuerp_goods_sales_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=销货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `receiving_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `sale_user` int(11) DEFAULT NULL COMMENT '销售员',
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_note` varchar(255) DEFAULT NULL COMMENT '商品备注',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `default_unit` int(11) DEFAULT NULL COMMENT '基本单位',
  `basic_nmber` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_price` double(15,4) DEFAULT '0.0000' COMMENT '销货单价',
  `cost_price` double(15,4) DEFAULT NULL COMMENT '成本价',
  `tax_included` double(15,4) DEFAULT '0.0000' COMMENT '含税单价',
  `discount` float(5,2) DEFAULT '0.00' COMMENT '折扣率',
  `dis_money` double(15,4) DEFAULT '0.0000' COMMENT '折扣额',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT '0.0000' COMMENT '税率',
  `tax_money` double(15,4) DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `customers_money` double(15,4) DEFAULT '0.0000' COMMENT '客户承担费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '收款状态:0=未收款,1=部分收款,2=全部收款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `order_info_id` varchar(255) DEFAULT NULL COMMENT '购货订单详情ID',
  `batch_id` int(11) DEFAULT NULL,
  `batch_name` varchar(100) DEFAULT NULL,
  `manufacture` int(11) DEFAULT NULL,
  `guarantee` int(11) DEFAULT NULL,
  `validity` int(11) DEFAULT NULL,
  `period` text COMMENT '序列号',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品销售明细';

CREATE TABLE IF NOT EXISTS `kuerp_goods_sales_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=销货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `receiving_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `sale_user` int(11) DEFAULT NULL COMMENT '销售员',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `purchase_id` varchar(50) DEFAULT NULL COMMENT '销货单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `discount` float(5,2) DEFAULT '10.00' COMMENT '折扣',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `tax_money` double(15,4) DEFAULT NULL COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `status` enum('0','1','2','3') DEFAULT '0' COMMENT '状态:0=未出库,1=全部出库,2=部分出库,3=已取消',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `store_number` double(15,4) DEFAULT '0.0000' COMMENT '入库数量',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `note` varchar(255) DEFAULT NULL COMMENT '备注',
  `arrears` double(15,4) DEFAULT '0.0000' COMMENT '本次欠款',
  `all_arrears` double(15,4) DEFAULT '0.0000' COMMENT '总欠款',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `purchase_code` (`purchase_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销货订单';

CREATE TABLE IF NOT EXISTS `kuerp_goods_sales_order_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=销货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `receiving_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `sale_user` int(11) DEFAULT NULL COMMENT '销售员',
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_note` varchar(255) DEFAULT NULL COMMENT '商品备注',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `purchase_number` double(15,4) DEFAULT '0.0000' COMMENT '可生成购货单数量',
  `default_unit` int(11) DEFAULT NULL COMMENT '基本单位',
  `basic_nmber` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_price` double(15,4) DEFAULT '0.0000' COMMENT '购货单价',
  `cost_price` double(15,4) DEFAULT NULL COMMENT '成本价',
  `tax_included` double(15,4) DEFAULT '0.0000' COMMENT '含税单价',
  `discount` double(15,4) DEFAULT '0.0000' COMMENT '折扣率',
  `dis_money` double(15,4) DEFAULT '0.0000' COMMENT '折扣额',
  `all_money` double(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT '0.0000' COMMENT '税率',
  `tax_money` double(15,4) DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT '0.0000' COMMENT '价税合计',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_id` varchar(50) DEFAULT NULL COMMENT '购货单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货订单号',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` float(11,2) DEFAULT '0.00' COMMENT '优惠额',
  `real_money` float(11,2) DEFAULT '0.00' COMMENT '优惠后金额',
  `purchase_money` float(11,2) DEFAULT '0.00' COMMENT '采购费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `status` enum('0','1','2','3') DEFAULT '0' COMMENT '状态:0=未出库,1=全部出库,2=部分出库,3=已取消',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` float(11,2) DEFAULT '0.00' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `library_number` int(11) DEFAULT '0' COMMENT '未入库数量',
  `library_money` float(11,2) DEFAULT '0.00' COMMENT '未入库金额',
  `library_time` bigint(16) DEFAULT NULL COMMENT '最后入库时间',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `purchase_code` (`purchase_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销货订单详情';

CREATE TABLE IF NOT EXISTS `kuerp_goods_sales_profit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `sale_user` int(11) DEFAULT NULL COMMENT '销售员',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT NULL COMMENT '业务类别:1=普通销售,2=销售退货',
  `number` double(15,4) DEFAULT NULL COMMENT '数量',
  `amount` double(15,4) DEFAULT NULL COMMENT '折扣额',
  `all_money` varchar(255) DEFAULT NULL COMMENT '销售收入',
  `tax_money` double(15,4) DEFAULT NULL COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `sales_cost` double(15,4) DEFAULT NULL COMMENT '销售成本',
  `preferential_money` double(15,4) DEFAULT NULL COMMENT '优惠额',
  `purchase_money` double(15,4) DEFAULT NULL COMMENT '销售费用',
  `real_money` double(15,4) DEFAULT NULL COMMENT '优惠后金额',
  `customers_money` double(15,4) DEFAULT NULL COMMENT '客户承担费用',
  `need_money` double(15,4) DEFAULT NULL COMMENT '应收金额',
  `pay_money` double(15,4) DEFAULT NULL COMMENT '已收款金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '整单备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销售利润表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_sales_summary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=购货,2=退货',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `delivery_time` bigint(16) DEFAULT NULL COMMENT '交货时间',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `receiving_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `sale_user` int(11) DEFAULT NULL COMMENT '销售员',
  `goods_code` varchar(30) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_note` varchar(255) DEFAULT NULL COMMENT '商品备注',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `default_unit` int(11) DEFAULT NULL COMMENT '基本单位',
  `basic_nmber` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_price` double(15,4) DEFAULT '0.0000' COMMENT '购货单价',
  `cost_price` double(15,4) DEFAULT NULL,
  `tax_included` double(15,4) DEFAULT NULL COMMENT '含税单价',
  `discount` float(5,2) DEFAULT '0.00' COMMENT '折扣率',
  `dis_money` double(15,4) DEFAULT '0.0000' COMMENT '折扣额',
  `all_money` float(15,4) DEFAULT '0.0000' COMMENT '购货金额',
  `tax_rate` double(15,4) DEFAULT '0.0000' COMMENT '税率',
  `tax_money` double(15,4) DEFAULT '0.0000' COMMENT '税额',
  `money_tax_price` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_order_id` varchar(50) DEFAULT NULL COMMENT '销货订单号',
  `sales_order_id` varchar(50) DEFAULT NULL COMMENT '销货单号',
  `returns_order_id` varchar(50) DEFAULT NULL COMMENT '退货单号',
  `preferential_rate` float(5,2) DEFAULT '0.00' COMMENT '优惠率',
  `preferential_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠额',
  `real_money` double(15,4) DEFAULT '0.0000' COMMENT '优惠后金额',
  `purchase_money` double(15,4) DEFAULT '0.0000' COMMENT '采购费用',
  `customers_money` double(15,4) DEFAULT '0.0000' COMMENT '客户承担费用',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=部分付款,2=全部付款',
  `check_status` enum('0','1') DEFAULT '0' COMMENT '对单状态:0=未对单,1=已对单',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已付款金额',
  `account` int(11) DEFAULT NULL COMMENT '付款账户',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `order_info_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL COMMENT '批次ID',
  `batch_name` varchar(100) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '过期时间',
  `period` text COMMENT '序列号',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销售汇总表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_serial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `goods_id` int(11) DEFAULT NULL COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `stores_id` int(11) unsigned DEFAULT NULL COMMENT '仓库ID',
  `attribute_id` varchar(255) DEFAULT NULL COMMENT '属性组合',
  `serial` varchar(30) DEFAULT NULL COMMENT '序列号',
  `status` enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15') DEFAULT '1' COMMENT '状态:1=购货,2=购货退货,3=销货,4=销货退货,5=盘点,6=其他,7=盘盈,8=其他入库,9=盘亏,10=其他出库,11=组合单,12=组合单,13=拆卸单,14=拆卸单,15=生产',
  `store_status` enum('0','1','2') DEFAULT '0' COMMENT '在库状态:0=未入库,1=在库,2=出库',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_id` int(11) DEFAULT NULL COMMENT '购货单ID',
  `purchase_code` varchar(30) DEFAULT NULL COMMENT '购货单单号',
  `purchase_exchange_id` int(11) DEFAULT NULL COMMENT '购货退货单ID',
  `purchase_exchange_code` varchar(30) DEFAULT NULL COMMENT '购货退货单单号',
  `sale_id` int(11) DEFAULT NULL COMMENT '销货单ID',
  `sale_code` varchar(30) DEFAULT NULL COMMENT '销货单号',
  `sale_exchange_id` int(11) DEFAULT NULL COMMENT '销货退货单ID',
  `sale_exchange_code` varchar(30) DEFAULT NULL COMMENT '销货退货单单号',
  `order_id` int(11) DEFAULT NULL COMMENT '来源ID',
  `warehousing_id` int(11) DEFAULT NULL COMMENT '入库单ID',
  `warehousing_status` enum('1','2') DEFAULT '1' COMMENT '是否其他入库:1=否,2=是',
  `warehoue_id` int(11) DEFAULT NULL COMMENT '出库单ID',
  `assemble_id` int(11) DEFAULT NULL COMMENT '组合单ID',
  `assemble_status` enum('1','2') DEFAULT '2' COMMENT '组装单入库',
  `split_id` int(11) DEFAULT NULL COMMENT '拆卸单ID',
  `split_status` enum('1','2') DEFAULT '2' COMMENT '拆卸单入库',
  `old_status` int(11) DEFAULT NULL,
  `old_store` int(11) DEFAULT NULL,
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品序列号';

CREATE TABLE IF NOT EXISTS `kuerp_goods_serial_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `goods_id` int(11) DEFAULT NULL COMMENT '商品ID',
  `stores_id` int(11) unsigned DEFAULT NULL COMMENT '仓库ID',
  `attribute_id` int(11) DEFAULT NULL COMMENT '属性组合',
  `serial` varchar(30) DEFAULT NULL COMMENT '序列号',
  `business_type` enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','16') DEFAULT NULL COMMENT '业务类型:1=期初,2=普通采购,3=采购退回,4=普通销售,5=销售退回,6=调拨单,,7=盘盈,8=其他入库,9=盘亏,10=其他出库,11=组合单,12=组合单,13=拆卸单,14=拆卸单,16=生产',
  `store_status` enum('0','1','2') DEFAULT '0' COMMENT '在库状态:0=未入库,1=在库,2=出库',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `purchase_id` int(11) DEFAULT NULL COMMENT '单据ID',
  `purchase_code` varchar(30) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `customer_id` int(11) DEFAULT NULL COMMENT '往来单位',
  `order_id` int(11) DEFAULT NULL COMMENT '来源ID',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品序列号跟踪';

CREATE TABLE IF NOT EXISTS `kuerp_goods_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `attribute_id` int(11) DEFAULT NULL COMMENT '属性组合ID',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库ID',
  `stock` double(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '库存',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=关仓,1=正常',
  `period` double(15,4) unsigned DEFAULT '0.0000' COMMENT '期初数量',
  `unit_cost` double(15,4) unsigned DEFAULT '0.0000' COMMENT '单位成本',
  `price` double(15,4) unsigned DEFAULT '0.0000' COMMENT '期初总价',
  `stock_warning` enum('0','1') DEFAULT '0' COMMENT '库存预警:0=否,1=是',
  `min_stock` double(15,4) DEFAULT '0.0000' COMMENT '最低库存',
  `max_stock` double(15,4) DEFAULT '0.0000' COMMENT '最高库存',
  `address` varchar(255) DEFAULT NULL COMMENT '产地',
  `registration` varchar(100) DEFAULT NULL COMMENT '注册证号',
  `production` varchar(100) DEFAULT NULL COMMENT '生产许可证',
  `cost_money` double(15,4) DEFAULT '0.0000' COMMENT '总成本',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品库存表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_stock_warning` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库ID',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=关仓,1=正常',
  `stock_warning` enum('0','1') DEFAULT '0' COMMENT '库存预警:0=否,1=是',
  `min_stock` double(15,4) unsigned DEFAULT NULL COMMENT '最低库存',
  `max_stock` double(15,4) unsigned DEFAULT NULL COMMENT '最高库存',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='商品库存预警表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_store_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT '0',
  `purchase_id` int(11) DEFAULT NULL,
  `number` double(15,4) DEFAULT '0.0000',
  `money` double(15,4) DEFAULT '0.0000',
  `all_money` double(15,4) DEFAULT '0.0000',
  `createtime` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='入库';

CREATE TABLE IF NOT EXISTS `kuerp_goods_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `supplier_type_name` varchar(120) NOT NULL DEFAULT '' COMMENT '类别名称',
  `supplier_type_image` varchar(255) DEFAULT NULL DEFAULT '' COMMENT '图片',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '上级',
  `path` varchar(255) DEFAULT NULL COMMENT 'path',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `weigh` int(11) DEFAULT '0',
  `order_status` enum('0','1') NULL DEFAULT '1' COMMENT '订货通显示状态:0=否,1=是',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='商品分类';

INSERT IGNORE INTO `kuerp_goods_type` (`id`,`admin_id`,`supplier_type_name`,`supplier_type_image`,`pid`,`path`,`status`,`weigh`,`createtime`,`updatetime`) VALUES
(1,NULL,'商品默认分类','/assets/img/qrcode.png',0,',0,','1',1,1644373315,1644388573);


CREATE TABLE IF NOT EXISTS `kuerp_income` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类型:1=其他收入,2=其他',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `accounts_id` int(11) DEFAULT NULL COMMENT '账户',
  `cost_id` int(11) DEFAULT NULL COMMENT '采购销售ID',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `pay_money` double(15,4) DEFAULT NULL COMMENT '已收金额',
  `arrears` double(15,4) DEFAULT NULL COMMENT '本次欠款',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `pay_status` enum('0','1','2') DEFAULT '0' COMMENT '付款状态:0=未付款,1=全部付款,2=部分付款',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='其他收入单';

CREATE TABLE IF NOT EXISTS `kuerp_income_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_id` int(11) DEFAULT NULL COMMENT '收入单ID',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类型:1=其他收入',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `income_type_id` int(11) DEFAULT NULL COMMENT '收入类别',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='其他收入单详情';

CREATE TABLE IF NOT EXISTS `kuerp_income_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `name` varchar(120) NOT NULL DEFAULT '' COMMENT '名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '上级分类id',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `path` varchar(255) DEFAULT NULL,
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='收入类别表';

INSERT IGNORE INTO `kuerp_income_type` (`id`,`admin_id`,`name`,`image`,`pid`,`status`,`path`,`createtime`,`updatetime`) VALUES
(1,NULL,'销货','/assets/img/qrcode.png',0,'1',',0,',1644373346,1644373346);


CREATE TABLE IF NOT EXISTS `kuerp_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '盘点编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '盘点时间',
  `store_type` enum('1','2') DEFAULT '1' COMMENT '盘点仓库:1=全部仓库,2=单仓',
  `result` varchar(255) DEFAULT NULL COMMENT '盘点结果',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='盘点';

CREATE TABLE IF NOT EXISTS `kuerp_inventory_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '盘点编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '盘点时间',
  `goods_type` int(11) DEFAULT NULL COMMENT '商品类别',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品ID',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库ID',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `stock` double(15,4) DEFAULT NULL COMMENT '系统库存',
  `invertory_stock` double(15,4) DEFAULT NULL COMMENT '盘点库存',
  `profit` double(15,4) DEFAULT NULL COMMENT '盘盈盘亏',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='盘点详情';

CREATE TABLE IF NOT EXISTS `kuerp_inventory_serial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '盘点编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '盘点时间',
  `store_type` enum('1','2') DEFAULT '1' COMMENT '盘点仓库:1=全部仓库,2=单仓',
  `result` varchar(255) DEFAULT NULL COMMENT '盘点结果',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='序列号盘点';

CREATE TABLE IF NOT EXISTS `kuerp_inventory_serial_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '盘点编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '盘点时间',
  `goods_type` int(11) DEFAULT NULL COMMENT '商品类别',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品ID',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库ID',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `stock` double(15,4) DEFAULT NULL COMMENT '系统库存',
  `invertory_stock` double(15,4) DEFAULT NULL COMMENT '盘点库存',
  `profit` double(15,4) DEFAULT NULL COMMENT '盘盈盘亏',
  `period_period` text COMMENT '盘点序列号',
  `matching` int(11) DEFAULT NULL COMMENT '匹配',
  `inventory` int(11) DEFAULT NULL COMMENT '盘盈',
  `loss` int(11) DEFAULT NULL COMMENT '盘亏',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='序列号盘点详情';

CREATE TABLE IF NOT EXISTS `kuerp_invoicing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `suppliers_code` varchar(50) DEFAULT NULL COMMENT '供应商编号',
  `status` enum('0','1','2','3','4','5') DEFAULT NULL COMMENT '状态:0=未付款,1=全部付款,2=部分付款,3=未退款,4=全部退款,5=部分退款',
  `bill_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `bill_code` varchar(50) DEFAULT NULL COMMENT '源单据编号',
  `bill_codes` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `tax` double(15,4) DEFAULT NULL COMMENT '税额',
  `real_money` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已开票金额',
  `give_money` double(15,4) DEFAULT NULL COMMENT '未开票金额',
  `invoice_status` enum('0','1') DEFAULT '0' COMMENT '开票状态:0=未开,1=已开',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='采购开票表';

CREATE TABLE IF NOT EXISTS `kuerp_invoicing_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `suppliers_code` varchar(50) DEFAULT NULL COMMENT '供应商编号',
  `status` enum('0','1','2','3','4','5') DEFAULT NULL COMMENT '状态:0=未付款,1=全部付款,2=部分付款,3=未退款,4=全部退款,5=部分退款',
  `bill_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `bill_code` varchar(50) DEFAULT NULL COMMENT '源单据编号',
  `bill_codes` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `tax` double(15,4) DEFAULT NULL COMMENT '税额',
  `real_money` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已开票金额',
  `give_money` double(15,4) DEFAULT NULL COMMENT '未开票金额',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `times` int(11) DEFAULT NULL COMMENT '开票时间',
  `invoice` varchar(255) DEFAULT NULL COMMENT '发票号',
  `invoice_header` varchar(255) DEFAULT NULL COMMENT '发票抬头',
  `invoicing_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='采购开票表';

CREATE TABLE IF NOT EXISTS `kuerp_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `business_type` enum('1','2') DEFAULT '1' COMMENT '类型:1=预付单,2=收款单',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `money` double(15,4) DEFAULT NULL COMMENT '付款合计',
  `write_off` double(15,4) DEFAULT NULL COMMENT '核销金额',
  `discount` double(15,4) DEFAULT NULL COMMENT '整单折扣',
  `advance` double(15,4) DEFAULT NULL COMMENT '预付款',
  `staff_member_id` int(11) unsigned DEFAULT NULL COMMENT '付款人',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `examine_status` enum('0','1') NOT NULL DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='付款单';

CREATE TABLE IF NOT EXISTS `kuerp_payment_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `collection_id` int(11) NOT NULL DEFAULT '0' COMMENT '收款单ID',
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `accounts_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结算账户',
  `money` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '付款金额',
  `settlementtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结算方式',
  `number` varchar(50) DEFAULT '' COMMENT '结算号',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='付款账户信息';

CREATE TABLE IF NOT EXISTS `kuerp_payment_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `suppliers_code` varchar(50) DEFAULT NULL COMMENT '供应商编号',
  `business_type` enum('1','2','3','4','5','6','7') DEFAULT NULL COMMENT '业务类型:1=普通采购,2=采购退回,3=付款,4=退款,5=期初应付款,6=期初预付款,7=核销',
  `bill_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `bill_code` varchar(50) DEFAULT NULL COMMENT '源单据编号',
  `bill_codes` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_money` double(15,4) DEFAULT NULL COMMENT '采购金额',
  `money_tax_price` double(15,4) DEFAULT NULL,
  `discount_money` double(15,4) DEFAULT NULL COMMENT '优惠金额',
  `real_money` double(15,4) DEFAULT NULL COMMENT '优惠后金额',
  `pay_money` double(15,4) DEFAULT NULL COMMENT '本次付款',
  `give_money` double(15,4) DEFAULT NULL COMMENT '应付款余额',
  `reamrk` varchar(255) DEFAULT NULL COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='采购付款一览表';

INSERT IGNORE INTO `kuerp_payment_log` (`id`,`admin_id`,`suppliers_code`,`business_type`,`bill_time`,`bill_code`,`bill_codes`,`purchase_money`,`money_tax_price`,`discount_money`,`real_money`,`pay_money`,`give_money`,`reamrk`,`createtime`) VALUES
(1,NULL,'GYS001','5',1644336000,'GYS001',NULL,NULL,NULL,NULL,NULL,NULL,0.0000,NULL,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_payment_sale` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `collection_id` int(11) NOT NULL DEFAULT '0' COMMENT '收款单ID',
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `purchase_number` varchar(50) NOT NULL DEFAULT '' COMMENT '原单编号',
  `business_type` enum('1','2','3','4','5','6') NOT NULL DEFAULT '1' COMMENT '单据类型:1=预收单,2=预付单,3=应收,4=应付,5=期初应收/付款,6=期初预收/付款',
  `times` int(11) NOT NULL DEFAULT '0' COMMENT '单据日期',
  `money` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '单据金额',
  `write_off` double(15,4) DEFAULT NULL COMMENT '已核销金额',
  `write_off_money` double(15,4) DEFAULT NULL COMMENT '未核销金额',
  `write_off_price` double(15,4) DEFAULT '0.0000' COMMENT '本次核销金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '单据备注',
  `old_money` double(15,4) DEFAULT NULL,
  `old_status` tinyint(3) DEFAULT NULL,
  `old_money_i` double(15,4) DEFAULT NULL,
  `old_status_i` tinyint(3) DEFAULT NULL,
  `business_name` varchar(255) DEFAULT NULL COMMENT '单据名称',
  `source_id` int(11) NOT NULL DEFAULT '0' COMMENT '源单ID',
  `type` enum('1','2','3','4') DEFAULT NULL COMMENT '类型:1=购货/销货,2=退货,3=期初,4=核销',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='付款单单据信息';

CREATE TABLE IF NOT EXISTS `kuerp_prefix` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '单据类型',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '单据',
  `prefix` varchar(10) NOT NULL DEFAULT '' COMMENT '前缀',
  `year` enum('1','2') NOT NULL DEFAULT '1' COMMENT '年',
  `month` enum('1','2') NOT NULL DEFAULT '1' COMMENT '月',
  `day` enum('1','2') NOT NULL DEFAULT '1' COMMENT '日',
  `hour` enum('1','2') NOT NULL DEFAULT '1' COMMENT '时',
  `minute` enum('1','2') NOT NULL DEFAULT '1' COMMENT '分',
  `second` enum('1','2') NOT NULL DEFAULT '1' COMMENT '秒',
  `start` int(11) unsigned DEFAULT NULL COMMENT '起始数',
  `strlen` int(11) unsigned DEFAULT '0' COMMENT '自定义数字长度',
  `example` varchar(50) DEFAULT NULL COMMENT '示例',
  `dbname` varchar(50) DEFAULT NULL COMMENT '表',
  `field` varchar(50) DEFAULT NULL COMMENT '字段名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `prefix` (`prefix`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COMMENT='单号设置';

INSERT IGNORE INTO `kuerp_prefix` (`id`, `admin_id`, `type`, `name`, `prefix`, `year`, `month`, `day`, `hour`, `minute`, `second`, `start`, `strlen`, `example`, `dbname`, `field`) VALUES
(1,1,1,'客户','KH','2','2','2','2','2','2',1,3,'KH001','kuerp_customers','customer_code'),
(2,1,2,'供应商','GYS','2','2','2','2','2','2',1,3,'GYS001','kuerp_suppliers','supplyer_code'),
(3,1,3,'职员','ZY','2','2','2','2','2','2',1,3,'ZY001','kuerp_staff_member','men_code'),
(4,1,4,'仓库','CK','2','2','2','2','2','2',1,3,'CK001','kuerp_stores','store_code'),
(5,1,5,'账户','ZH','2','2','2','2','2','2',1,3,'ZH001','kuerp_accounts','account_coding'),
(6,1,6,'商品','SP','2','2','2','2','2','2',1,3,'SP001','kuerp_goods','goods_code'),
(7,1,7,'购货订单','GHDD','1','1','1','2','2','2',1,3,'GHDD20210925001','kuerp_goods_purchase_order','purchase_code'),
(8,1,8,'购货单','GHD','1','1','1','2','2','2',1,3,'GHD20210925001','kuerp_goods_purchase','purchase_code'),
(9,1,9,'购货退货单','GHTH','1','1','1','2','2','2',1,3,'GHTH20210925001','kuerp_goods_exchange','purchase_code'),
(10,1,10,'销货订单','XHDD','1','1','1','2','2','2',1,3,'XHDD20210925001','kuerp_goods_sales_order','purchase_code'),
(11,1,11,'销货单','XHD','1','1','1','2','2','2',1,3,'XHD20210925001','kuerp_goods_sales','purchase_code'),
(12,1,12,'销货退货单','XHTH','1','1','1','2','2','2',1,3,'XHTH20210925001','kuerp_goods_sales_exchange','purchase_code'),
(13,1,13,'调拨单','DB','1','1','1','2','2','2',1,3,'DB20210925001','kuerp_allocation','purchase_code'),
(14,1,14,'成本调整单','CBTZ','1','1','1','2','2','2',1,3,'CBTZ20210925001','kuerp_adjustment','purchase_code'),
(15,1,15,'盘点','PD','1','1','1','2','2','2',1,3,'PD20210925001','kuerp_inventory','purchase_code'),
(16,1,16,'序列号盘点','XLHPD','1','1','1','2','2','2',1,3,'XLHPD20210925001','kuerp_inventory_serial','purchase_code'),
(17,1,17,'其他入库单','QTRK','1','1','1','2','2','2',1,3,'QTRK20210925001','kuerp_warehousing','purchase_code'),
(18,1,18,'其他出库单','QTCK','1','1','1','2','2','2',1,3,'QTCK20210925001','kuerp_warehouse','purchase_code'),
(19,1,19,'组装单','ZZ','1','1','1','2','2','2',1,3,'ZZ20210925001','kuerp_assemble','purchase_code'),
(20,1,20,'拆卸单','CX','1','1','1','2','2','2',1,3,'CX20210925001','kuerp_split','purchase_code'),
(21,1,21,'收款单','SK','1','1','1','2','2','2',1,3,'SK20210925001','kuerp_collection','purchase_code'),
(22,1,22,'付款单','FK','1','1','1','2','2','2',1,3,'FK20210925001','kuerp_payment','purchase_code'),
(23,1,23,'核销单','HX','1','1','1','2','2','2',1,3,'HX20210925001','kuerp_writeoff','purchase_code'),
(24,1,24,'其他收入单','QTSR','1','1','1','2','2','2',1,3,'QTSR20210925001','kuerp_income','purchase_code'),
(25,1,25,'其他支出单','QTZC','1','1','1','2','2','2',1,3,'QTZC20210925001','kuerp_expenditure','purchase_code'),
(26,1,26,'资金转账单','ZJZZ','1','1','1','2','2','2',1,3,'ZJZZ20210925001','kuerp_accounts_transfer','purchase_code'),
(27,1,27,'采购销售费用','CXFY','1','1','1','2','2','2',1,3,'CXFY20210925001','kuerp_cost','purchase_code');

CREATE TABLE IF NOT EXISTS `kuerp_sales_invoicing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `status` enum('0','1','2','3','4','5') DEFAULT NULL COMMENT '状态:0=未收款,1=全部收款,2=部分收款,3=未退款,4=全部退款,5=部分退款',
  `bill_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `bill_code` varchar(50) DEFAULT NULL COMMENT '源单据编号',
  `bill_codes` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `tax` double(15,4) DEFAULT NULL COMMENT '税额',
  `real_money` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `customers_money` double(15,4) DEFAULT '0.0000' COMMENT '客户承担费用',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已开票金额',
  `give_money` double(15,4) DEFAULT NULL COMMENT '未开票金额',
  `invoice_status` enum('0','1') DEFAULT '0' COMMENT '开票状态:0=未开,1=已开',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销货开票表';

CREATE TABLE IF NOT EXISTS `kuerp_sales_invoicing_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `status` enum('0','1','2','3','4','5') DEFAULT NULL COMMENT '状态:0=未收款,1=全部收款,2=部分收款,3=未退款,4=全部退款,5=部分退款',
  `bill_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `bill_code` varchar(50) DEFAULT NULL COMMENT '源单据编号',
  `bill_codes` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `money` double(15,4) DEFAULT NULL COMMENT '金额',
  `tax` double(15,4) DEFAULT NULL COMMENT '税额',
  `real_money` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `customers_money` double(15,4) DEFAULT '0.0000' COMMENT '客户承担费用',
  `pay_money` double(15,4) DEFAULT '0.0000' COMMENT '已开票金额',
  `give_money` double(15,4) DEFAULT NULL COMMENT '未开票金额',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `times` int(11) DEFAULT NULL COMMENT '开票时间',
  `invoice` varchar(255) DEFAULT NULL COMMENT '发票号',
  `invoice_header` varchar(255) DEFAULT NULL COMMENT '发票抬头',
  `invoicing_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='销货开票表';

CREATE TABLE IF NOT EXISTS `kuerp_sales_payment_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `sale_user` int(11) DEFAULT NULL COMMENT '销售员',
  `business_type` enum('1','2','3','4','5','6','7') DEFAULT NULL COMMENT '业务类型:1=销货,2=销货退回,3=付款,4=退款,5=期初应收款,6=期初预收款,7=核销',
  `bill_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `bill_code` varchar(50) DEFAULT NULL COMMENT '源单据编号',
  `bill_codes` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_money` double(15,4) DEFAULT NULL COMMENT '销售金额',
  `money_tax_price` double(15,4) DEFAULT NULL COMMENT '价税合计',
  `discount_money` double(15,4) DEFAULT NULL COMMENT '优惠金额',
  `real_money` double(15,4) DEFAULT NULL COMMENT '优惠后金额',
  `customers_money` double(15,4) DEFAULT '0.0000' COMMENT '客户承担费用',
  `pay_money` double(15,4) DEFAULT NULL COMMENT '本次付款',
  `give_money` double(15,4) DEFAULT NULL COMMENT '应收款余额',
  `reamrk` varchar(255) DEFAULT NULL COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='销货收款一览表';

INSERT IGNORE INTO `kuerp_sales_payment_log` (`id`,`admin_id`,`customers_id`,`sale_user`,`business_type`,`bill_time`,`bill_code`,`bill_codes`,`purchase_money`,`money_tax_price`,`discount_money`,`real_money`,`customers_money`,`pay_money`,`give_money`,`reamrk`,`createtime`) VALUES
(1,NULL,1,NULL,'5',1644336000,'KH001',NULL,NULL,NULL,NULL,NULL,0.0000,NULL,0.0000,NULL,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_sets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `type` tinyint(3) DEFAULT '1' COMMENT '类型:1=基础参数,2=功能参数',
  `name` varchar(100) DEFAULT NULL COMMENT '变量名称',
  `nickname` varchar(100) DEFAULT NULL COMMENT '名称',
  `value` varchar(255) DEFAULT NULL COMMENT '设置值',
  `is_edit` enum('0','1') DEFAULT '0' COMMENT '修改:0=允许,1=不允许',
  `notice` varchar(255) DEFAULT NULL COMMENT '提示',
  `explain` varchar(255) DEFAULT NULL COMMENT '说明',
  `is_checked` tinyint(3) DEFAULT '0' COMMENT '是否选中',
  `set` text COMMENT '场景',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COMMENT='设置';

INSERT IGNORE INTO `kuerp_sets` (`id`, `admin_id`, `type`, `name`, `nickname`, `value`, `is_edit`, `notice`, `explain`, `is_checked`, `set`) VALUES
(1,1,1,'company_name','公司名称','XX公司','0',NULL,NULL,0,NULL),
(2,1,1,'company_address','公司地址','XX公司地址','0',NULL,NULL,0,NULL),
(3,1,1,'company_phone','公司电话','0816-6666666','0',NULL,NULL,0,NULL),
(4,1,1,'company_tax','公司传真','','0',NULL,NULL,0,NULL),
(5,1,1,'company_zipcode','公司邮编','123456','0',NULL,NULL,0,NULL),
(6,1,1,'enable_time','启用时间','2021-08-19','1',NULL,NULL,0,NULL),
(7,1,1,'base_currency','本位币','RMB','1',NULL,NULL,0,NULL),
(8,1,1,'price_decimal','价格小数位数','1','0','小数位由小改大后将不能再改小,请慎重!',NULL,0,NULL),
(9,1,1,'number_decimal','数量小数位数','0','0','小数位由小改大后将不能再改小,请慎重!',NULL,0,NULL),
(10,1,1,'valuation','存货计价方法','1','0',NULL,NULL,0,NULL),
(11,1,2,'examine','启用审核','','0',NULL,'（启用后单据只有在审核后才会生效，报表数据才会变化）',1,NULL),
(12,1,2,'taxes','启用税金','13','0','','增值税税率',0,NULL),
(13,1,2,'price_taxes','商品价格是否含税','','0','','勾选后，商品资料中预设的采购和销售价格，对应购货、销货类单据中的含税单价列，不勾选则对应不含税单价列',0,NULL),
(14,1,2,'auxiliary','启用辅助属性','','0','','（启用后允许商品新增服装、尺码等自定义属性）',0,NULL),
(15,1,2,'serial','启用序列号','','0','','（启用后将新增商品序列号管理功能）',0,NULL),
(16,1,2,'batch','启用批次保质期管理','','0','','（启用后将新增商品保质期管理功能）',0,NULL),
(17,1,2,'earing','启用自动出库最早批次','','0','','（启用后录入出库类单据时，会自动选择商品最早时间的批次）',0,''),
(19,1,2,'stores','启用分仓核算','','0','','（启用后将商品的成本将根据各分仓核算, 未启用根据总仓核算）',0,''),
(20,1,2,'no_edittime','启用销售类单据不允许修改单据日期','','0','(销货订单、销货单、销货退货单)','启用后，在进销存网页版新增销货订单、销货单、退货单时，默认为当前日期，且不允许修改',0,''),
(21,1,2,'discount','开票金额取优惠后金额','','0','','勾选后销售开票的金额的取值取优惠后金额，不勾选取价税合计金额 (注意！本参数勾选后将不能取消！)',0,''),
(22,1,2,'customer','启用单据新增客户/供应商取上一次的值','','0','(购货类单据、销货类单据)','勾选后新增购货类单据、销货类单据会默认取上一次的供应商、客户，不勾选新增购货类单据、销货类单据供应商、客户默认为空',0,''),
(23,1,2,'last_read','启用销货类单据新增销售人员默认取上一张单据的值','','0','','勾选表示单据新增销售人员会取上一张单据的销售人员，不勾选则取该客户上一次对应的销售人员(如果客户有维护默认销售人员都会取默认销售人员，和参数无关)',0,''),
(24,1,3,'price_sale','商品价格策略',NULL,'0',NULL,'启用后会根据客户等级来取商品价格策略中维护的值，如选择的是批发客户，则取商品对应的批发价',0,NULL),
(25,1,3,'price_buy','商品价格策略',NULL,'0',NULL,'启用后会取商品管理中商品维护的预计采购价',0,NULL),
(26,1,3,'price_sale_last','最近售价',NULL,'0',NULL,'启用后会根据客户自动带入上一次的销售价格',0,NULL),
(27,1,3,'price_buy_last','最近采购价',NULL,'0',NULL,'启用后会根据供应商自动带入上一次的采购价格',0,NULL),
(28,1,4,'secret','小程序秘钥',NULL,'0',NULL,'小程序必须携带此参数才能访问小程序接口',0,NULL),
(29,1,4,'appid','小程序appid',NULL,'0',NULL,NULL,0,NULL),
(30,1,4,'appsecret','小程序秘钥',NULL,'0',NULL,NULL,0,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_settlementtype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '结算方式名称',
  `image` varchar(255) DEFAULT NULL DEFAULT '' COMMENT '图片',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '结算方式状态:0=禁用,1=启用',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '编辑时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='结算方式表';

INSERT IGNORE INTO `kuerp_settlementtype` (`id`,`admin_id`,`name`,`image`,`status`,`createtime`,`updatetime`,`deletetime`) VALUES
(1,NULL,'现金','/assets/img/qrcode.png','1',1644373356,1644373356,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_spendingtype` (
  `id` int(11) NOT NULL,
  `spending_type_name` varchar(120) NOT NULL DEFAULT '' COMMENT '类型名称',
  `spending_type_image` varchar(255) DEFAULT NULL DEFAULT '' COMMENT '图片',
  `status` enum('0','1') DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='支出类别表';

CREATE TABLE IF NOT EXISTS `kuerp_split` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类型:1=拆卸单',
  `money` double(15,4) DEFAULT NULL COMMENT '费用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='拆卸单';

CREATE TABLE IF NOT EXISTS `kuerp_split_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') NOT NULL DEFAULT '1' COMMENT '类型:1=拆卸单',
  `type` enum('1','2') NOT NULL DEFAULT '2' COMMENT '类型:1=组合件,2=子件',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(50) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) NOT NULL DEFAULT '0' COMMENT '商品单位',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `period` text COMMENT '序列号',
  `basic_number` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_cost` double DEFAULT '0' COMMENT '单位成本',
  `cost_money` double DEFAULT '0' COMMENT '成本',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `batch_id` int(11) DEFAULT NULL COMMENT '批次ID',
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '过期时间',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='拆卸单详情';

CREATE TABLE IF NOT EXISTS `kuerp_split_info_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') NOT NULL DEFAULT '1' COMMENT '类型:1=拆卸单',
  `type` enum('1','2') NOT NULL DEFAULT '2' COMMENT '类型:1=组合件,2=子件',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_code` varchar(50) NOT NULL DEFAULT '' COMMENT '商品编号',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) NOT NULL DEFAULT '0' COMMENT '商品单位',
  `stores_id` int(11) NOT NULL DEFAULT '0' COMMENT '仓库',
  `allow_stock` double(15,4) DEFAULT '0.0000' COMMENT '可用库存',
  `number` double(15,4) DEFAULT '0.0000' COMMENT '数量',
  `period` text COMMENT '序列号',
  `basic_number` double(15,4) DEFAULT '0.0000' COMMENT '基本数量',
  `unit_cost` double DEFAULT '0' COMMENT '单位成本',
  `cost_money` double DEFAULT '0' COMMENT '成本',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `batch_id` int(11) DEFAULT NULL COMMENT '批次ID',
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `manufacture` int(11) DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '过期时间',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT '0' COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='拆卸单详情模板';

CREATE TABLE IF NOT EXISTS `kuerp_split_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `temp_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模板名称',
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据日期',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类型:1=拆卸单',
  `money` double(15,4) DEFAULT NULL COMMENT '费用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `examine_status` enum('0','1') DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='拆卸单模板';

CREATE TABLE IF NOT EXISTS `kuerp_staff_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `men_code` varchar(100) DEFAULT NULL COMMENT '职员编号',
  `name` varchar(100) DEFAULT NULL COMMENT '职员名称',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `status` enum('0','1') DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='职员表';

INSERT IGNORE INTO `kuerp_staff_member` (`id`,`admin_id`,`men_code`,`name`,`phone`,`status`,`createtime`,`updatetime`) VALUES
(1,NULL,'ZY001','默认职员','13999999999','1',NULL,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_stores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `store_code` varchar(30) NOT NULL DEFAULT '' COMMENT '仓库编号',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '仓库名称',
  `status` enum('0','1') DEFAULT '1' COMMENT '状态:0=关闭,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='仓库表';

INSERT IGNORE INTO `kuerp_stores` (`id`,`admin_id`,`store_code`,`name`,`status`,`createtime`,`updatetime`) VALUES
(1,NULL,'CK001','默认仓库','1',1644373416,1644388527);


CREATE TABLE IF NOT EXISTS `kuerp_suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `supplyer_code` varchar(30) NOT NULL DEFAULT '' COMMENT '供应商编号',
  `supplyertype_id` int(11) NOT NULL DEFAULT '0' COMMENT '供应商类别',
  `supplyer_name` varchar(120) NOT NULL COMMENT '供应商名称',
  `first_connect_name` varchar(100) NOT NULL DEFAULT '' COMMENT '联系人',
  `first_connect_mobile` varchar(11) NOT NULL COMMENT '手机',
  `first_connect_phone` varchar(20) DEFAULT '' COMMENT '座机',
  `qq_wx_email` varchar(120) DEFAULT '' COMMENT 'QQ/微信/Email',
  `connect_address` varchar(255) DEFAULT '' COMMENT '联系地址',
  `note` varchar(255) DEFAULT '' COMMENT '备注',
  `need_give_account` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '应付款余额',
  `receive_account` double(15,4) DEFAULT NULL COMMENT '期初应付款',
  `account_time` bigint(11) unsigned DEFAULT NULL COMMENT '余额日期',
  `opening_payable` double(15,4) unsigned DEFAULT '0.0000' COMMENT '期初应付款',
  `opening_prepayment` double(15,4) unsigned DEFAULT '0.0000' COMMENT '期初预付款',
  `vat_rate` double(15,4) unsigned DEFAULT NULL COMMENT '增值税税率',
  `identification` varchar(50) DEFAULT NULL COMMENT '纳税人识别号',
  `deposit_bank` varchar(150) DEFAULT NULL COMMENT '开户银行',
  `bank_number` varchar(30) DEFAULT NULL COMMENT '银行卡号',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='供应商表';

INSERT IGNORE INTO `kuerp_suppliers` (`id`,`admin_id`,`supplyer_code`,`supplyertype_id`,`supplyer_name`,`first_connect_name`,`first_connect_mobile`,`first_connect_phone`,`qq_wx_email`,`connect_address`,`note`,`need_give_account`,`receive_account`,`account_time`,`opening_payable`,`opening_prepayment`,`vat_rate`,`identification`,`deposit_bank`,`bank_number`,`status`,`createtime`,`updatetime`) VALUES
(1,NULL,'GYS001',1,'默认供应商','默认供应商','13555555555','','','供应商地址','默认供应商',0.00,0.0000,1644336000,0.0000,0.0000,13.0000,'','','','1',NULL,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_suppliers_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `supplyer_code` varchar(30) NOT NULL DEFAULT '' COMMENT '供应商编号',
  `sid` int(11) unsigned DEFAULT NULL COMMENT '供应商ID',
  `first_connect_name` varchar(100) NOT NULL DEFAULT '' COMMENT '联系人名称',
  `first_connect_mobile` varchar(11) NOT NULL COMMENT '手机',
  `first_connect_phone` varchar(20) NOT NULL COMMENT '座机',
  `qq_wx_email` varchar(120) NOT NULL COMMENT 'QQ/微信/Email',
  `connect_address` varchar(255) NOT NULL COMMENT '联系地址',
  `is_first` tinyint(3) DEFAULT '0' COMMENT '首要联系人:0=否,1=是',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='供应商联系人';

INSERT IGNORE INTO `kuerp_suppliers_user` (`id`,`admin_id`,`supplyer_code`,`sid`,`first_connect_name`,`first_connect_mobile`,`first_connect_phone`,`qq_wx_email`,`connect_address`,`is_first`,`status`,`createtime`,`updatetime`,`deletetime`) VALUES
(1,NULL,'GYS001',1,'默认供应商','13555555555','','','供应商地址',1,'1',1644375294,1644375294,NULL);


CREATE TABLE IF NOT EXISTS `kuerp_supplyertype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `supplier_type_name` varchar(120) NOT NULL DEFAULT '' COMMENT '类别名称',
  `supplier_type_img` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '上级',
  `path` varchar(255) DEFAULT NULL COMMENT 'path',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `weigh` int(11) DEFAULT NULL,
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='供应商分类';

INSERT IGNORE INTO `kuerp_supplyertype` (`id`,`admin_id`,`supplier_type_name`,`supplier_type_img`,`pid`,`path`,`status`,`weigh`,`createtime`,`updatetime`) VALUES
(1,NULL,'供应商默认分类','/assets/img/qrcode.png',0,',0,','1',1,1644375252,1644375308);


CREATE TABLE IF NOT EXISTS `kuerp_transfers` (
  `id` int(11) NOT NULL,
  `documents_code` varchar(50) NOT NULL COMMENT '单据编号',
  `documents_date` varchar(50) NOT NULL COMMENT '单据日期',
  `goods_code` varchar(100) NOT NULL COMMENT '商品编号',
  `goods_type_id` int(11) NOT NULL COMMENT '商品类别',
  `goodsnote` text NOT NULL COMMENT '商品备注',
  `createtime` bigint(16) NOT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NOT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  `num` int(11) NOT NULL COMMENT '数量',
  `unit_id` int(11) NOT NULL COMMENT '单位',
  `out_store_id` int(11) NOT NULL COMMENT '调出仓库',
  `to_store_id` int(11) NOT NULL COMMENT '调入仓库',
  `maker_id` int(11) NOT NULL COMMENT '制单人',
  `fl_note` text NOT NULL COMMENT '分录备注',
  `audit` varchar(100) NOT NULL COMMENT '审核人',
  `main_note` text NOT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `kuerp_unit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL COMMENT '单位名称',
  `type` enum('1','2') DEFAULT '1' COMMENT '类型:1=单一单位,2=多单位',
  `is_main` enum('0','1') DEFAULT '0' COMMENT '是否主单位:0=否,1=是',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='计量单位';

INSERT IGNORE INTO `kuerp_unit` (`id`,`admin_id`,`name`,`type`,`is_main`,`createtime`,`updatetime`) VALUES
(1,NULL,'个','1','0',1644373366,1644373366);


CREATE TABLE IF NOT EXISTS `kuerp_unit_conversion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `unit_name` varchar(255) DEFAULT NULL,
  `main_unit` int(11) NOT NULL DEFAULT '0' COMMENT '主计量单位',
  `vice_unit` int(11) NOT NULL DEFAULT '0' COMMENT '副计量单位',
  `advance_rate` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '换算进率',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='计量单位换算';


CREATE TABLE IF NOT EXISTS `kuerp_warehouse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类别:1=盘亏,2=其他出库',
  `number` double(15,4) DEFAULT NULL COMMENT '数量',
  `price` double(15,4) DEFAULT NULL COMMENT '金额',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `examine_status` enum('0','1') NOT NULL DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `order_id` int(11) DEFAULT NULL COMMENT '盘点单ID',
  `order_type` enum('1','2') DEFAULT NULL COMMENT '单据类型:1=盘点,2=序列号盘点',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='其他出库单';

CREATE TABLE IF NOT EXISTS `kuerp_warehouse_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '盘点编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '盘点时间',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `stock` double(15,4) DEFAULT NULL COMMENT '可用库存',
  `number` double(15,4) DEFAULT NULL COMMENT '数量',
  `basic_nmber` double(15,4) DEFAULT NULL COMMENT '基础数量',
  `period` text COMMENT '序列号',
  `unit_price` double(15,4) DEFAULT NULL COMMENT '出库单价',
  `price` double(15,4) DEFAULT NULL COMMENT '出库金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `batch_id` int(11) DEFAULT NULL COMMENT '批次ID',
  `manufacture` int(11) DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '有效期至',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='其他出库单详情';

CREATE TABLE IF NOT EXISTS `kuerp_warehousing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `business_type` enum('1','2') DEFAULT NULL COMMENT '业务类别:1=盘盈,2=其他入库',
  `number` double(15,4) DEFAULT NULL COMMENT '数量',
  `price` double(15,4) DEFAULT NULL COMMENT '金额',
  `suppliers_id` int(11) DEFAULT NULL COMMENT '供应商',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `examine_status` enum('0','1') NOT NULL DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `order_id` int(11) DEFAULT NULL COMMENT '盘点单ID',
  `order_type` enum('1','2') DEFAULT NULL COMMENT '单据类型:1=盘点,2=序列号盘点',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='其他入库单';

CREATE TABLE IF NOT EXISTS `kuerp_warehousing_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '盘点编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '盘点时间',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `stores_id` int(11) DEFAULT NULL COMMENT '仓库',
  `stock` double(15,4) DEFAULT NULL COMMENT '可用库存',
  `number` double(15,4) DEFAULT NULL COMMENT '数量',
  `basic_nmber` double(15,4) DEFAULT NULL COMMENT '基础数量',
  `period` text COMMENT '序列号',
  `unit_price` double(15,4) DEFAULT NULL COMMENT '入库单价',
  `price` double(15,4) DEFAULT NULL COMMENT '入库金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `batch_id` int(11) DEFAULT NULL COMMENT '批次ID',
  `manufacture` int(11) DEFAULT NULL COMMENT '生产日期',
  `guarantee` int(11) DEFAULT NULL COMMENT '保质期',
  `validity` int(11) DEFAULT NULL COMMENT '有效期至',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='其他入库单详情';

CREATE TABLE IF NOT EXISTS `kuerp_writeoff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `business_type` enum('1','2','3','4','5') NOT NULL DEFAULT '1' COMMENT '类型:1=预收冲应收,2=预付冲应付,3=应收冲应付,4=应收转应收,5=应付转应付',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户',
  `customers_out_id` int(11) DEFAULT NULL COMMENT '转出客户',
  `customers_enter_id` int(11) DEFAULT NULL COMMENT '转入客户',
  `suppliers_id` int(11) DEFAULT NULL COMMENT '供应商',
  `suppliers_out_id` int(11) DEFAULT NULL COMMENT '转出供应商',
  `suppliers_enter_id` int(11) DEFAULT NULL COMMENT '转入供应商',
  `write_off` double(15,4) DEFAULT NULL COMMENT '核销金额',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `preparation_id` int(11) DEFAULT NULL COMMENT '制单人',
  `examine_id` int(11) DEFAULT NULL COMMENT '审核人',
  `operation_id` int(11) DEFAULT NULL COMMENT '最后操作人',
  `examine_time` bigint(16) DEFAULT NULL COMMENT '审核时间',
  `examine_status` enum('0','1') NOT NULL DEFAULT '0' COMMENT '审核状态:0=未审核,1=已审核',
  `print_num` int(11) DEFAULT NULL COMMENT '打印次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='核销单';

CREATE TABLE IF NOT EXISTS `kuerp_writeoff_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `collection_id` int(11) NOT NULL DEFAULT '0' COMMENT '核销单ID',
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '单据编号',
  `purchase_type` enum('1','2','3','4','5','6') DEFAULT NULL COMMENT '单据类型:1=预收单,2=预付单,3=应收,4=应付,5=期初应收/付款,6=期初预收/付款',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `type` enum('1','2','3','4','5','6') DEFAULT '1' COMMENT '类型:1=购货/销货,2=退货,3=期初,4=核销',
  `purchase_number` varchar(50) NOT NULL DEFAULT '' COMMENT '原单编号',
  `business_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '类型:1=预收冲应收,2=预付冲应付,3=应收冲应付,4=应收转应收,5=应付转应付',
  `times` int(11) NOT NULL DEFAULT '0' COMMENT '单据日期',
  `money` double(15,4) NOT NULL DEFAULT '0.0000' COMMENT '单据金额',
  `write_off` double(15,4) DEFAULT NULL COMMENT '已核销金额',
  `write_off_money` double(15,4) DEFAULT NULL COMMENT '未核销金额',
  `write_off_price` double(15,4) DEFAULT '0.0000' COMMENT '本次核销金额',
  `old_money` double(15,4) DEFAULT NULL,
  `old_status` int(11) DEFAULT NULL,
  `top` enum('1','2') DEFAULT '1' COMMENT '位置:1=上,2=下',
  `source_id` int(11) DEFAULT NULL COMMENT '源单ID',
  `business_name` varchar(255) DEFAULT NULL COMMENT '单据名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='核销单据信息';

CREATE TABLE IF NOT EXISTS `kuerp_writeoff_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL COMMENT '源单ID',
  `write_off` double(15,4) DEFAULT NULL COMMENT '未核销金额',
  `money` double(15,4) DEFAULT NULL COMMENT '已核销金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='核销单据信息';

CREATE TABLE IF NOT EXISTS `kuerp_writeoff_source` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `purchase_type` enum('1','2','3','4','5','6') DEFAULT NULL COMMENT '单据类型:1=预收单,2=预付单,3=应收,4=应付,5=期初应收/付款,6=期初预收/付款',
  `type` enum('1','2','3','4') DEFAULT NULL COMMENT '类型:1=购货/销货,2=退货,3=期初,4=核销',
  `suppliers_code` varchar(50) DEFAULT NULL COMMENT '供应商编号',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户Id',
  `purchase_code` varchar(50) NOT NULL DEFAULT '' COMMENT '原单编号',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `price` double(15,4) DEFAULT '0.0000' COMMENT '单据金额',
  `money` double(15,4) DEFAULT '0.0000' COMMENT '已核销金额',
  `write_off` double(15,4) DEFAULT '0.0000' COMMENT '未核销金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COMMENT='核销单源单';


CREATE TABLE IF NOT EXISTS `kuerp_banner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) DEFAULT NULL,
  `name` varchar(120) NOT NULL DEFAULT '' COMMENT '名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `link` varchar(255) DEFAULT '' COMMENT '链接',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COMMENT='轮播表';

CREATE TABLE IF NOT EXISTS `kuerp_banner_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL DEFAULT '' COMMENT '名称',
  `type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '广告位',
  `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='轮播位表';
INSERT IGNORE INTO `kuerp_banner_type` (`id`,`name`,`type`,`status`,`createtime`,`updatetime`) VALUES (1,'首页广告',1,'1',1640534400,1640534400);

CREATE TABLE IF NOT EXISTS `kuerp_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(11) DEFAULT NULL,
  `group_id` int(10) unsigned NULL DEFAULT '0' COMMENT '组别ID',
  `username` varchar(32)  DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50)  DEFAULT '' COMMENT '昵称',
  `password` varchar(32)  DEFAULT '' COMMENT '密码',
  `salt` varchar(30)  DEFAULT '' COMMENT '密码盐',
  `email` varchar(100)  DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11)  DEFAULT '' COMMENT '手机号',
  `avatar` varchar(255)  DEFAULT '' COMMENT '头像',
  `level` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `gender` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '性别',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `bio` varchar(100)  DEFAULT '' COMMENT '格言',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '积分',
  `successions` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '连续登录天数',
  `maxsuccessions` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '最大连续登录天数',
  `prevtime` bigint(16) DEFAULT NULL COMMENT '上次登录时间',
  `logintime` bigint(16) DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50)  DEFAULT '' COMMENT '登录IP',
  `loginfailure` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '失败次数',
  `joinip` varchar(50)  DEFAULT '' COMMENT '加入IP',
  `jointime` bigint(16) DEFAULT NULL COMMENT '加入时间',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  `token` varchar(50)  DEFAULT '' COMMENT 'Token',
  `status` varchar(30)  DEFAULT '' COMMENT '状态',
  `verification` varchar(255)  DEFAULT '' COMMENT '验证',
  `binding` tinyint(3) NOT NULL DEFAULT '2' COMMENT '是否绑定',
  `customers_id` int(11) DEFAULT NULL COMMENT '客户ID',
  PRIMARY KEY (`id`),
  KEY `email` (`email`),
  KEY `mobile` (`mobile`),
  KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='会员表';

CREATE TABLE IF NOT EXISTS `kuerp_user_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `connect_name` varchar(100) NOT NULL COMMENT '联系人',
  `connect_mobile` varchar(11) NOT NULL COMMENT '手机号码',
  `province` int(11) NOT NULL DEFAULT '0' COMMENT '省',
  `city` int(11) NOT NULL DEFAULT '0' COMMENT '市',
  `area` int(11) NOT NULL DEFAULT '0' COMMENT '区',
  `detail_address` varchar(255) NOT NULL COMMENT '详细地址',
  `is_default` enum('0','1') NOT NULL DEFAULT '0' COMMENT '默认地址:0=否,1=是',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='收货地址表';

CREATE TABLE IF NOT EXISTS `kuerp_user_cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `number` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '数量',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

CREATE TABLE IF NOT EXISTS `kuerp_user_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `name` varchar(30)  DEFAULT '' COMMENT '变量名',
  `group` varchar(30)  DEFAULT '' COMMENT '分组',
  `title` varchar(100)  DEFAULT '' COMMENT '变量标题',
  `tip` varchar(100)  DEFAULT '' COMMENT '变量描述',
  `type` varchar(30)  DEFAULT '' COMMENT '类型:string,text,int,bool,array,datetime,date,file',
  `value` text  COMMENT '变量值',
  `content` text  COMMENT '变量字典数据',
  `rule` varchar(100)  DEFAULT '' COMMENT '验证规则',
  `extend` varchar(255)  DEFAULT '' COMMENT '扩展属性',
  `setting` varchar(255)  DEFAULT '' COMMENT '配置',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COMMENT='系统配置';

INSERT IGNORE INTO `kuerp_user_config` (`id`,`admin_id`,`name`,`group`,`title`,`tip`,`type`,`value`,`content`,`rule`,`extend`,`setting`) VALUES
(1,NULL,'version','','版本','','','1.0.0',NULL,'','',''),
(2,NULL,'agreement','','用户协议','','','用户协议',NULL,'','',''),
(3,NULL,'privacy','','隐私协议','','','隐私协议',NULL,'','',''),
(4,NULL,'notice','','公告','','','公告',NULL,'','',''),
(5,NULL,'appid','','AppId','','','AppId',NULL,'','',''),
(6,NULL,'appsecret','','AppSecret','','','AppSecret',NULL,'','',''),
(7,NULL,'indextitle','','首页名称','','','订货通',NULL,'','',''),
(8,NULL,'price_status','','是否显示价格','','','1',NULL,'','',''),
(9,NULL,'speed','','滚动速度','','','30',NULL,'','',''),
(10,NULL,'pay_status','','开启在线支付','','','0',NULL,'','',''),
(11, NULL, 'order_send', '', '同步发货信息', '', '4', '0', NULL, '', '', ''),
(12, NULL, 'order_send_name', '', '发货人名称', '', '4', '', NULL, '', '', ''),
(13, NULL, 'order_send_phone', '', '发货人电话', '', '4', '', NULL, '', '', '');

CREATE TABLE IF NOT EXISTS `kuerp_user_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `look_date` varchar(50) DEFAULT NULL COMMENT '日期',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='浏览历史表';

CREATE TABLE IF NOT EXISTS `kuerp_user_oauth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) DEFAULT '0' COMMENT '用户',
  `provider` varchar(50) NOT NULL COMMENT '厂商',
  `platform` varchar(50) NOT NULL COMMENT '平台',
  `unionid` varchar(50) DEFAULT NULL COMMENT '厂商ID',
  `openid` varchar(50) NOT NULL COMMENT '平台ID',
  `nickname` varchar(255) DEFAULT '' COMMENT '昵称',
  `sex` tinyint(1) DEFAULT '0' COMMENT '性别',
  `country` varchar(50) DEFAULT NULL COMMENT '国家',
  `province` varchar(50) DEFAULT NULL COMMENT '省',
  `city` varchar(50) DEFAULT NULL COMMENT '市',
  `headimgurl` varchar(500) DEFAULT '' COMMENT '头像',
  `logintime` bigint(16) DEFAULT NULL COMMENT '登录时间',
  `logincount` int(11) DEFAULT '0' COMMENT '累计登陆',
  `expire_in` int(11) DEFAULT NULL COMMENT '过期周期(s)',
  `expiretime` bigint(16) DEFAULT NULL COMMENT '过期时间',
  `session_key` varchar(45) DEFAULT '' COMMENT 'session_key',
  `refresh_token` varchar(110) DEFAULT NULL COMMENT 'refresh_token',
  `access_token` varchar(110) DEFAULT NULL COMMENT 'access_token',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='第三方授权';

CREATE TABLE IF NOT EXISTS `kuerp_user_order` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `name` varchar(255) DEFAULT NULL COMMENT '姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系方式',
  `address` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `order_num` varchar(50) DEFAULT '' COMMENT '订单号',
  `order_price` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '订单价格',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '状态:0=待审核,1=已审核,2=待发货,3=待收货,4=已收货,5=退款中,6=退款完成,7=交易取消,8=交易完成',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `pay_status` tinyint(3) unsigned DEFAULT '0' COMMENT '支付状态:0=支付中,1=支付成功,2=支付失败',
  `pay_time` bigint(16) unsigned DEFAULT NULL COMMENT '付款时间',
  `diver_type` enum('1','2') DEFAULT '1' COMMENT '配送类型:1=专业配送,2=到店自取',
  `store_id` int(11) DEFAULT NULL COMMENT '门店ID',
  `diver_id` int(11) DEFAULT NULL COMMENT '司机ID',
  `diver_name` varchar(255) DEFAULT NULL COMMENT '司机姓名',
  `diver_phone` varchar(100) DEFAULT NULL COMMENT '司机电话',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
  `express_code` varchar(20) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '快递公司编号',
  `express_name` varchar(255) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '快递公司名称',
  `express_num` varchar(100) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '快递单号',
  `pay_info` text CHARACTER SET utf8 NULL COMMENT '支付信息',
  `send_code` varchar(255) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '同步状态码',
  `send_msg` varchar(255) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '同步信息',
  `numb` int(11) NULL DEFAULT 1 COMMENT '当月序号',
  `goods_images` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '附件',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

CREATE TABLE IF NOT EXISTS `kuerp_user_orderinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `order_id` int(11) DEFAULT NULL COMMENT '订单ID',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
  `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
  `goods_name` varchar(255) DEFAULT NULL COMMENT '商品名称',
  `goods_image` varchar(255) DEFAULT NULL COMMENT '商品图片',
  `unit_name` varchar(255) DEFAULT NULL COMMENT '单位名称',
  `attr_name` varchar(255) DEFAULT NULL COMMENT '属性名称',
  `number` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '数量',
  `price` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
  `money` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '总价',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订货单详情表';

CREATE TABLE IF NOT EXISTS `kuerp_user_ordersale` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL COMMENT '订单ID',
  `sales_id` int(11) NOT NULL DEFAULT '0' COMMENT '销货单ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订货单关联表';

CREATE TABLE IF NOT EXISTS `kuerp_user_sets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) DEFAULT '1' COMMENT '类型:1=基础参数,2=功能参数',
  `name` varchar(100) DEFAULT NULL COMMENT '变量名称',
  `nickname` varchar(100) DEFAULT NULL COMMENT '名称',
  `value` varchar(255) DEFAULT NULL COMMENT '设置值',
  `is_edit` enum('0','1') DEFAULT '0' COMMENT '修改:0=允许,1=不允许',
  `notice` varchar(255) DEFAULT NULL COMMENT '提示',
  `explain` varchar(255) DEFAULT NULL COMMENT '说明',
  `is_checked` tinyint(3) DEFAULT '0' COMMENT '是否选中',
  `set` text COMMENT '场景',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订货通设置';

INSERT IGNORE INTO `kuerp_user_sets` (`id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`) VALUES
(1,1,'appid','AppId','AppId','0',NULL,NULL,0,NULL),
(2,1,'appsecret','AppSecret','AppSecret','0','','',0,NULL),
(3,1,'mch_id','商户号','','0',NULL,NULL,0,NULL),
(4,1,'pay_key','支付秘钥','','0','','',0,NULL),
(5,1,'template_xd','下单消息模板','','0',NULL,NULL,0,NULL),
(6,1,'template_sh','审核消息模板','','0',NULL,NULL,0,NULL),
(7,1,'template_fh','发货消息模板','','0',NULL,NULL,0,NULL);

CREATE TABLE IF NOT EXISTS `kuerp_user_ordersaleinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sales_id` int(11) DEFAULT NULL COMMENT '销货单ID',
  `orderinfo_id` int(11) DEFAULT NULL COMMENT '订单详情ID',
  `salesinfo_id` int(11) NOT NULL DEFAULT '0' COMMENT '销货单详情ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订货单详情关联表';

CREATE TABLE IF NOT EXISTS `kuerp_enclosure` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
   `type` enum('1','2') DEFAULT '1' COMMENT '类型:1=购货,2=销货',
   `status` enum('0','1') DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
   `upload_date` varchar(30) DEFAULT NULL COMMENT '上传日期',
   `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
   `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='原始单据表';

CREATE TABLE IF NOT EXISTS `kuerp_enclosure_log` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `enclosure_id` int(11) NOT NULL DEFAULT '0' COMMENT '附件ID',
   `order_id` int(11) DEFAULT '0' COMMENT '单据ID',
   `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
   `type` enum('1','2','3','4','5','6') DEFAULT NULL COMMENT '单据类型:1=购货订单,2:购货单,3:购货退货单,4:销货订单,5:销货单,6:销货退货单',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='原始单据关联表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_salethird` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `order_num` varchar(100) DEFAULT '0' COMMENT '外部订单号',
   `purchase_id` int(11) DEFAULT NULL COMMENT '销货单ID',
   `third_id` int(11) DEFAULT NULL COMMENT '三方ID',
   `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
   `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='三方销售订单关联';

CREATE TABLE IF NOT EXISTS `kuerp_third_account` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `name` varchar(120) NOT NULL DEFAULT '' COMMENT '名称',
   `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
   `account` varchar(30) NOT NULL DEFAULT '' COMMENT '账号',
   `salt` varchar(100) DEFAULT NULL COMMENT '秘钥',
   `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
   `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
   `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='接口账号表';

CREATE TABLE IF NOT EXISTS `kuerp_goods_exchangethird` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `order_num` varchar(100) DEFAULT '0' COMMENT '外部订单号',
   `purchase_id` int(11) DEFAULT NULL COMMENT '销货单ID',
   `third_id` int(11) DEFAULT NULL COMMENT '三方ID',
   `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
   `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='三方销售退货单关联';

CREATE TABLE IF NOT EXISTS `kuerp_config` (
   `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
   `admin_id` int(11) DEFAULT NULL,
   `name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量名',
   `group` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '分组',
   `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量标题',
   `tip` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量描述',
   `type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '类型:string,text,int,bool,array,datetime,date,file',
   `value` text COLLATE utf8mb4_unicode_ci COMMENT '变量值',
   `content` text COLLATE utf8mb4_unicode_ci COMMENT '变量字典数据',
   `rule` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '验证规则',
   `extend` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '扩展属性',
   `setting` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '配置',
   PRIMARY KEY (`id`),
   UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='系统配置';
INSERT IGNORE INTO `kuerp_config` VALUES
(1,NULL,'version','','','','','1.0.0',NULL,'','',''),
(2,NULL,'agreement','','','','','用户协议',NULL,'','',''),
(3,NULL,'privacy','','','','','隐私协议',NULL,'','',''),
(4,NULL,'share_img','','','','','/uploads/20220120/80411b8473afcdd8814851e781a41442.png',NULL,'','',''),
(5,NULL,'stock_tips','','','','','<p>
	<strong><span style="font-size:14px;">1.</span></strong><span style="font-size:14px;">可用库存的取值逻辑是取单据新增时选择商品+仓库的可用库存,取出来之后会进行保存,后期</span><span style="color:#E53333;font-size:14px;">不会随着商品的库存变化而自动发生变化,如需查看库存请点击仓库前面的放大镜按钮查看</span><br />
<strong><span style="font-size:14px;">2</span></strong><span style="font-size:14px;">.举例:商品a在仓库a的即时库存10,可用库存9</span><br />
<span style="font-size:14px;">&nbsp;&nbsp;</span><strong><span style="font-size:14px;">1)</span></strong><span style="font-size:14px;">新增销货单,选择商品a和仓库a,可用库存显示的是9,单据保存</span><br />
<span style="font-size:14px;">&nbsp;&nbsp;</span><strong><span style="font-size:14px;">2)</span></strong><span style="font-size:14px;">新增购货单选择商品a和仓库a,入库数量10,单据审核</span><br />
<span style="font-size:14px;">&nbsp;&nbsp;</span><strong><span style="font-size:14px;">3)</span></strong><span style="font-size:14px;">找到刚刚保存的销货单,查看商品a和仓库a的可用库存显示是9,请注意这里不会是19,因为可用库存不会重新获取。</span>
</p>',NULL,'','','');
INSERT IGNORE INTO `kuerp_user_config` (`id`,`admin_id`,`name`,`group`,`title`,`tip`,`type`,`value`,`content`,`rule`,`extend`,`setting`) VALUES
(10,NULL,'pay_status','','开启在线支付','','','0',NULL,'','','');
CREATE TABLE IF NOT EXISTS `kuerp_user_applet` (
   `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
   `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
   `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '组名',
   `rules` text COLLATE utf8mb4_unicode_ci COMMENT '权限节点',
   `applet` text COLLATE utf8mb4_unicode_ci COMMENT '小程序规则',
   `createtime` bigint(16) DEFAULT NULL COMMENT '添加时间',
   `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
   `status` enum('normal','hidden') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态',
   `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员常用设置表';
CREATE TABLE IF NOT EXISTS `kuerp_driver` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `admin_id` int(11) DEFAULT NULL,
   `name` varchar(100) DEFAULT NULL COMMENT '名称',
   `phone` varchar(20) DEFAULT NULL COMMENT '电话',
   `plate` varchar(100) DEFAULT NULL COMMENT '车牌号',
   `status` enum('0','1') DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
   `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
   `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='司机表';

CREATE TABLE IF NOT EXISTS `kuerp_checkout` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `checkdate` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '结账日期',
  `checktime` bigint(16) DEFAULT NULL COMMENT '结账日期',
  `preparation_id` int(11) DEFAULT NULL COMMENT '操作人',
  `preparation_time` bigint(16) DEFAULT NULL COMMENT '操作日期',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='结账表';

CREATE TABLE IF NOT EXISTS `kuerp_checkout_info` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `checkout_id` int(11) DEFAULT NULL COMMENT '结账ID',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品名称',
  `goods_code` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '商品编号',
  `basic_nmber` decimal(15,4) DEFAULT '0.0000' COMMENT '数量',
  `all_money` decimal(15,4) DEFAULT '0.0000' COMMENT '成本',
  `purchase_id` int(11) DEFAULT NULL COMMENT '结账截止购货ID',
  `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
  `av_basic_nmber` decimal(15,4) DEFAULT '0.0000' COMMENT '移动平均数量',
  `av_all_money` decimal(15,4) DEFAULT '0.0000' COMMENT '移动平均成本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='结账详情表';



--
-- 1.0.5
-- 添加支出类别字段pid,path，收入类别字段pid,path
--
ALTER TABLE `kuerp_expend_type` ADD COLUMN `pid` int(11) DEFAULT 0 COMMENT '上级分类id' AFTER `image`;
ALTER TABLE `kuerp_expend_type` ADD COLUMN `path` varchar(255) NULL DEFAULT '' COMMENT 'path' AFTER `status`;
ALTER TABLE `kuerp_income_type` ADD COLUMN `pid` int(11) DEFAULT 0 COMMENT '上级分类id' AFTER `image`;
ALTER TABLE `kuerp_income_type` ADD COLUMN `path` varchar(255) NULL DEFAULT '' COMMENT 'path' AFTER `status`;

--
-- 1.0.6
-- 添加原始单据
--
CREATE TABLE IF NOT EXISTS `kuerp_enclosure` (
                                                         `id` int(11) NOT NULL AUTO_INCREMENT,
                                                         `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
                                                         `type` enum('1','2') DEFAULT '1' COMMENT '类型:1=购货,2=销货',
                                                         `status` enum('0','1') DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
                                                         `upload_date` varchar(30) DEFAULT NULL COMMENT '上传日期',
                                                         `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                         `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                         PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='原始单据表';

CREATE TABLE IF NOT EXISTS `kuerp_enclosure_log` (
                                                             `id` int(11) NOT NULL AUTO_INCREMENT,
                                                             `enclosure_id` int(11) NOT NULL DEFAULT '0' COMMENT '附件ID',
                                                             `order_id` int(11) DEFAULT '0' COMMENT '单据ID',
                                                             `purchase_code` varchar(50) DEFAULT NULL COMMENT '单据编号',
                                                             `type` enum('1','2','3','4','5','6') DEFAULT NULL COMMENT '单据类型:1=购货订单,2:购货单,3:购货退货单,4:销货订单,5:销货单,6:销货退货单',
                                                             PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='原始单据关联表';

--
-- 1.0.8
-- 添加序列号状态保存
--
ALTER TABLE `kuerp_goods_exchange_info` ADD COLUMN `period` text COMMENT '序列号' AFTER `validity`;
ALTER TABLE `kuerp_goods_sales_info` ADD COLUMN `period` text COMMENT '序列号' AFTER `validity`;
ALTER TABLE `kuerp_goods_sales_exchange_info` ADD COLUMN `period` text COMMENT '序列号' AFTER `validity`;
ALTER TABLE `kuerp_goods_sales_summary` ADD COLUMN `period` text COMMENT '序列号' AFTER `validity`;

--
-- 1.1.0
-- 添加订货单模块，修改算法
--

ALTER TABLE `kuerp_goods` ADD COLUMN `content` text DEFAULT null COMMENT '商品详情' AFTER `goods_images`;
ALTER TABLE `kuerp_goods` ADD COLUMN `tag` set('hot','sale') DEFAULT 'sale' COMMENT '标签' AFTER `serial`;
ALTER TABLE `kuerp_goods` ADD COLUMN `sale_number` double(15,4) DEFAULT '0.0000' COMMENT '销量' AFTER `tag`;

ALTER TABLE `kuerp_area` DROP `mergename`;
ALTER TABLE `kuerp_area` DROP `pinyin`;
ALTER TABLE `kuerp_area` DROP `code`;
ALTER TABLE `kuerp_area` DROP `zip`;
ALTER TABLE `kuerp_area` DROP `first`;
ALTER TABLE `kuerp_area` ADD COLUMN `adcode` varchar(100) DEFAULT NULL COMMENT '地区编号' AFTER `level`;

CREATE TABLE IF NOT EXISTS `kuerp_banner` (
                                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                                      `type_id` int(11) DEFAULT NULL,
                                                      `name` varchar(120) NOT NULL DEFAULT '' COMMENT '名称',
                                                      `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
                                                      `link` varchar(255) DEFAULT '' COMMENT '链接',
                                                      `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
                                                      `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                      `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COMMENT='轮播表';

CREATE TABLE IF NOT EXISTS `kuerp_banner_type` (
                                                           `id` int(11) NOT NULL AUTO_INCREMENT,
                                                           `name` varchar(120) NOT NULL DEFAULT '' COMMENT '名称',
                                                           `type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '广告位',
                                                           `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
                                                           `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                           `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                           PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='轮播位表';
INSERT IGNORE INTO `kuerp_banner_type` (`id`,`name`,`type`,`status`,`createtime`,`updatetime`) VALUES (1,'首页广告',1,'1',1640534400,1640534400);

CREATE TABLE IF NOT EXISTS `kuerp_user` (
                                                    `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
                                                    `admin_id` int(11) DEFAULT NULL,
                                                    `group_id` int(10) unsigned NULL DEFAULT '0' COMMENT '组别ID',
                                                    `username` varchar(32)  DEFAULT '' COMMENT '用户名',
                                                    `nickname` varchar(50)  DEFAULT '' COMMENT '昵称',
                                                    `password` varchar(32)  DEFAULT '' COMMENT '密码',
                                                    `salt` varchar(30)  DEFAULT '' COMMENT '密码盐',
                                                    `email` varchar(100)  DEFAULT '' COMMENT '电子邮箱',
                                                    `mobile` varchar(11)  DEFAULT '' COMMENT '手机号',
                                                    `avatar` varchar(255)  DEFAULT '' COMMENT '头像',
                                                    `level` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
                                                    `gender` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '性别',
                                                    `birthday` date DEFAULT NULL COMMENT '生日',
                                                    `bio` varchar(100)  DEFAULT '' COMMENT '格言',
                                                    `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
                                                    `score` int(10) NOT NULL DEFAULT '0' COMMENT '积分',
                                                    `successions` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '连续登录天数',
                                                    `maxsuccessions` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '最大连续登录天数',
                                                    `prevtime` bigint(16) DEFAULT NULL COMMENT '上次登录时间',
                                                    `logintime` bigint(16) DEFAULT NULL COMMENT '登录时间',
                                                    `loginip` varchar(50)  DEFAULT '' COMMENT '登录IP',
                                                    `loginfailure` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '失败次数',
                                                    `joinip` varchar(50)  DEFAULT '' COMMENT '加入IP',
                                                    `jointime` bigint(16) DEFAULT NULL COMMENT '加入时间',
                                                    `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                    `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                    `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
                                                    `token` varchar(50)  DEFAULT '' COMMENT 'Token',
                                                    `status` varchar(30)  DEFAULT '' COMMENT '状态',
                                                    `verification` varchar(255)  DEFAULT '' COMMENT '验证',
                                                    `binding` tinyint(3) NOT NULL DEFAULT '2' COMMENT '是否绑定',
                                                    `customers_id` int(11) DEFAULT NULL COMMENT '客户ID',
                                                    PRIMARY KEY (`id`),
                                                    KEY `email` (`email`),
                                                    KEY `mobile` (`mobile`),
                                                    KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='会员表';

CREATE TABLE IF NOT EXISTS `kuerp_user_address` (
                                                            `id` int(11) NOT NULL AUTO_INCREMENT,
                                                            `admin_id` int(11) DEFAULT NULL,
                                                            `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
                                                            `connect_name` varchar(100) NOT NULL COMMENT '联系人',
                                                            `connect_mobile` varchar(11) NOT NULL COMMENT '手机号码',
                                                            `province` int(11) NOT NULL DEFAULT '0' COMMENT '省',
                                                            `city` int(11) NOT NULL DEFAULT '0' COMMENT '市',
                                                            `area` int(11) NOT NULL DEFAULT '0' COMMENT '区',
                                                            `detail_address` varchar(255) NOT NULL COMMENT '详细地址',
                                                            `is_default` enum('0','1') NOT NULL DEFAULT '0' COMMENT '默认地址:0=否,1=是',
                                                            `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                            `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                            PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='收货地址表';

CREATE TABLE IF NOT EXISTS `kuerp_user_cart` (
                                                         `id` int(11) NOT NULL AUTO_INCREMENT,
                                                         `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
                                                         `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
                                                         `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
                                                         `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
                                                         `number` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '数量',
                                                         `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                         `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                         PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

CREATE TABLE IF NOT EXISTS `kuerp_user_config` (
                                                           `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
                                                           `admin_id` int(11) DEFAULT NULL,
                                                           `name` varchar(30)  DEFAULT '' COMMENT '变量名',
                                                           `group` varchar(30)  DEFAULT '' COMMENT '分组',
                                                           `title` varchar(100)  DEFAULT '' COMMENT '变量标题',
                                                           `tip` varchar(100)  DEFAULT '' COMMENT '变量描述',
                                                           `type` varchar(30)  DEFAULT '' COMMENT '类型:string,text,int,bool,array,datetime,date,file',
                                                           `value` text  COMMENT '变量值',
                                                           `content` text  COMMENT '变量字典数据',
                                                           `rule` varchar(100)  DEFAULT '' COMMENT '验证规则',
                                                           `extend` varchar(255)  DEFAULT '' COMMENT '扩展属性',
                                                           `setting` varchar(255)  DEFAULT '' COMMENT '配置',
                                                           PRIMARY KEY (`id`),
                                                           UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='系统配置';

INSERT IGNORE INTO `kuerp_user_config` (`id`,`admin_id`,`name`,`group`,`title`,`tip`,`type`,`value`,`content`,`rule`,`extend`,`setting`) VALUES
(1,NULL,'version','','版本','','','1.0.0',NULL,'','',''),
(2,NULL,'agreement','','用户协议','','','用户协议',NULL,'','',''),
(3,NULL,'privacy','','隐私协议','','','隐私协议',NULL,'','',''),
(4,NULL,'notice','','公告','','','公告',NULL,'','',''),
(5,NULL,'appid','','AppId','','','AppId',NULL,'','',''),
(6,NULL,'appsecret','','AppSecret','','','AppSecret',NULL,'','',''),
(7,NULL,'indextitle','','首页名称','','','订货通',NULL,'','',''),
(8,NULL,'price_status','','是否显示价格','','','1',NULL,'','',''),
(9,NULL,'speed','','滚动速度','','','30',NULL,'','',''),
(10,NULL,'pay_status','','开启在线支付','','','0',NULL,'','','');

CREATE TABLE IF NOT EXISTS `kuerp_user_history` (
                                                            `id` int(11) NOT NULL AUTO_INCREMENT,
                                                            `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
                                                            `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
                                                            `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
                                                            `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
                                                            `look_date` varchar(50) DEFAULT NULL COMMENT '日期',
                                                            `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                            `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                            PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='浏览历史表';

CREATE TABLE IF NOT EXISTS `kuerp_user_oauth` (
                                                          `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
                                                          `user_id` int(10) DEFAULT '0' COMMENT '用户',
                                                          `provider` varchar(50) NOT NULL COMMENT '厂商',
                                                          `platform` varchar(50) NOT NULL COMMENT '平台',
                                                          `unionid` varchar(50) DEFAULT NULL COMMENT '厂商ID',
                                                          `openid` varchar(50) NOT NULL COMMENT '平台ID',
                                                          `nickname` varchar(255) DEFAULT '' COMMENT '昵称',
                                                          `sex` tinyint(1) DEFAULT '0' COMMENT '性别',
                                                          `country` varchar(50) DEFAULT NULL COMMENT '国家',
                                                          `province` varchar(50) DEFAULT NULL COMMENT '省',
                                                          `city` varchar(50) DEFAULT NULL COMMENT '市',
                                                          `headimgurl` varchar(500) DEFAULT '' COMMENT '头像',
                                                          `logintime` bigint(16) DEFAULT NULL COMMENT '登录时间',
                                                          `logincount` int(11) DEFAULT '0' COMMENT '累计登陆',
                                                          `expire_in` int(11) DEFAULT NULL COMMENT '过期周期(s)',
                                                          `expiretime` bigint(16) DEFAULT NULL COMMENT '过期时间',
                                                          `session_key` varchar(45) DEFAULT '' COMMENT 'session_key',
                                                          `refresh_token` varchar(110) DEFAULT NULL COMMENT 'refresh_token',
                                                          `access_token` varchar(110) DEFAULT NULL COMMENT 'access_token',
                                                          `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                          `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                          PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='第三方授权';

CREATE TABLE IF NOT EXISTS `kuerp_user_order` (
                                                          `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                                          `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
                                                          `name` varchar(255) DEFAULT NULL COMMENT '姓名',
                                                          `phone` varchar(20) DEFAULT NULL COMMENT '联系方式',
                                                          `address` varchar(255) DEFAULT NULL COMMENT '详细地址',
                                                          `order_num` varchar(50) DEFAULT '' COMMENT '订单号',
                                                          `order_price` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '订单价格',
                                                          `status` tinyint(3) unsigned DEFAULT '0' COMMENT '状态:0=待审核,1=已审核,2=待发货,3=待收货,4=已收货,5=退款中,6=退款完成,7=交易取消,8=交易完成',
                                                          `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                                                          `pay_status` tinyint(3) unsigned DEFAULT '0' COMMENT '支付状态:0=支付中,1=支付成功,2=支付失败',
                                                          `pay_time` bigint(16) unsigned DEFAULT NULL COMMENT '付款时间',
                                                          `diver_type` enum('1','2') DEFAULT '1' COMMENT '配送类型:1=专业配送,2=到店自取',
                                                          `store_id` int(11) DEFAULT NULL COMMENT '门店ID',
                                                          `diver_id` int(11) DEFAULT NULL COMMENT '司机ID',
                                                          `diver_name` varchar(255) DEFAULT NULL COMMENT '司机姓名',
                                                          `diver_phone` varchar(100) DEFAULT NULL COMMENT '司机电话',
                                                          `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                          `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                          `deletetime` bigint(16) DEFAULT NULL COMMENT '删除时间',
                                                          PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

CREATE TABLE IF NOT EXISTS `kuerp_user_orderinfo` (
                                                              `id` int(11) NOT NULL AUTO_INCREMENT,
                                                              `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
                                                              `order_id` int(11) DEFAULT NULL COMMENT '订单ID',
                                                              `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
                                                              `goods_unit` int(11) DEFAULT NULL COMMENT '商品单位',
                                                              `goods_attr` int(11) DEFAULT NULL COMMENT '商品属性',
                                                              `goods_name` varchar(255) DEFAULT NULL COMMENT '商品名称',
                                                              `goods_image` varchar(255) DEFAULT NULL COMMENT '商品图片',
                                                              `unit_name` varchar(255) DEFAULT NULL COMMENT '单位名称',
                                                              `attr_name` varchar(255) DEFAULT NULL COMMENT '属性名称',
                                                              `number` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '数量',
                                                              `price` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
                                                              `money` float(11,2) NOT NULL DEFAULT '0.00' COMMENT '总价',
                                                              `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                              `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                              PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订货单详情表';

CREATE TABLE IF NOT EXISTS `kuerp_user_ordersale` (
                                                              `id` int(11) NOT NULL AUTO_INCREMENT,
                                                              `order_id` int(11) DEFAULT NULL COMMENT '订单ID',
                                                              `sales_id` int(11) NOT NULL DEFAULT '0' COMMENT '销货单ID',
                                                              PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订货单关联表';

CREATE TABLE IF NOT EXISTS `kuerp_user_sets` (
                                                         `id` int(11) NOT NULL AUTO_INCREMENT,
                                                         `type` tinyint(3) DEFAULT '1' COMMENT '类型:1=基础参数,2=功能参数',
                                                         `name` varchar(100) DEFAULT NULL COMMENT '变量名称',
                                                         `nickname` varchar(100) DEFAULT NULL COMMENT '名称',
                                                         `value` varchar(255) DEFAULT NULL COMMENT '设置值',
                                                         `is_edit` enum('0','1') DEFAULT '0' COMMENT '修改:0=允许,1=不允许',
                                                         `notice` varchar(255) DEFAULT NULL COMMENT '提示',
                                                         `explain` varchar(255) DEFAULT NULL COMMENT '说明',
                                                         `is_checked` tinyint(3) DEFAULT '0' COMMENT '是否选中',
                                                         `set` text COMMENT '场景',
                                                         PRIMARY KEY (`id`),
                                                         UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订货通设置';

INSERT IGNORE INTO `kuerp_user_sets` (`id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`) VALUES
(1,1,'appid','AppId','AppId','0',NULL,NULL,0,NULL),
(2,1,'appsecret','AppSecret','AppSecret','0','','',0,NULL),
(3,1,'mch_id','商户号','','0',NULL,NULL,0,NULL),
(4,1,'pay_key','支付秘钥','','0','','',0,NULL),
(5,1,'template_xd','下单消息模板','','0',NULL,NULL,0,NULL),
(6,1,'template_sh','审核消息模板','','0',NULL,NULL,0,NULL),
(7,1,'template_fh','发货消息模板','','0',NULL,NULL,0,NULL);

CREATE TABLE IF NOT EXISTS `kuerp_user_ordersaleinfo` (
                                                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                                                  `sales_id` int(11) DEFAULT NULL COMMENT '销货单ID',
                                                                  `orderinfo_id` int(11) DEFAULT NULL COMMENT '订单详情ID',
                                                                  `salesinfo_id` int(11) NOT NULL DEFAULT '0' COMMENT '销货单详情ID',
                                                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订货单详情关联表';

CREATE TABLE IF NOT EXISTS `kuerp_checkout` (
                                                        `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                                                        `checkdate` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '结账日期',
                                                        `checktime` bigint(16) DEFAULT NULL COMMENT '结账日期',
                                                        `preparation_id` int(11) DEFAULT NULL COMMENT '操作人',
                                                        `preparation_time` bigint(16) DEFAULT NULL COMMENT '操作日期',
                                                        `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                        `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='结账表';

CREATE TABLE IF NOT EXISTS `kuerp_checkout_info` (
                                                             `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                                                             `checkout_id` int(11) DEFAULT NULL COMMENT '结账ID',
                                                             `goods_id` int(11) DEFAULT NULL COMMENT '商品名称',
                                                             `goods_code` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '商品编号',
                                                             `basic_nmber` decimal(15,4) DEFAULT '0.0000' COMMENT '数量',
                                                             `all_money` decimal(15,4) DEFAULT '0.0000' COMMENT '成本',
                                                             `purchase_id` int(11) DEFAULT NULL COMMENT '结账截止购货ID',
                                                             `purchase_time` bigint(16) DEFAULT NULL COMMENT '单据时间',
                                                             `av_basic_nmber` decimal(15,4) DEFAULT '0.0000' COMMENT '移动平均数量',
                                                             `av_all_money` decimal(15,4) DEFAULT '0.0000' COMMENT '移动平均成本',
                                                             PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='结账详情表';

--
-- 1.1.2
-- 添加商品类别，商品可设置订货通是否显示
--
ALTER TABLE `kuerp_goods_type` ADD COLUMN `order_status` enum('0','1') NULL DEFAULT '1' COMMENT '订货通显示状态:0=否,1=是' AFTER `weigh`;
ALTER TABLE `kuerp_goods` ADD COLUMN `order_status` enum('0','1') NULL DEFAULT '1' COMMENT '订货通显示状态:0=否,1=是' AFTER `sale_number`;

--
-- 1.1.3
-- 添加价格取数优先级，修改数量
--
INSERT IGNORE INTO `kuerp_sets` (`id`, `admin_id`, `type`, `name`, `nickname`, `value`, `is_edit`, `notice`, `explain`, `is_checked`, `set`) VALUES
(24,1,3,'price_sale','商品价格策略',NULL,'0',NULL,'启用后会根据客户等级来取商品价格策略中维护的值，如选择的是批发客户，则取商品对应的批发价',0,NULL),
(25,1,3,'price_buy','商品价格策略',NULL,'0',NULL,'启用后会取商品管理中商品维护的预计采购价',0,NULL),
(26,1,3,'price_sale_last','最近售价',NULL,'0',NULL,'启用后会根据客户自动带入上一次的销售价格',0,NULL),
(27,1,3,'price_buy_last','最近采购价',NULL,'0',NULL,'启用后会根据供应商自动带入上一次的采购价格',0,NULL);

ALTER TABLE `kuerp_goods_sales_profit` ENGINE=INNODB;
ALTER TABLE `kuerp_goods_exchange_info` MODIFY COLUMN `basic_nmber` double(15,4) DEFAULT '0.0000';
ALTER TABLE `kuerp_goods_purchase_info` MODIFY COLUMN `basic_nmber` double(15,4) DEFAULT '0.0000';
ALTER TABLE `kuerp_goods_purchase_order_info` MODIFY COLUMN `basic_nmber` double(15,4) DEFAULT '0.0000';
ALTER TABLE `kuerp_goods_purchase_summary` MODIFY COLUMN `basic_nmber` double(15,4) DEFAULT '0.0000';
ALTER TABLE `kuerp_goods_sales_exchange_info` MODIFY COLUMN `basic_nmber` double(15,4) DEFAULT '0.0000';
ALTER TABLE `kuerp_goods_sales_info` MODIFY COLUMN `basic_nmber` double(15,4) DEFAULT '0.0000';
ALTER TABLE `kuerp_goods_sales_order_info` MODIFY COLUMN `basic_nmber` double(15,4) DEFAULT '0.0000';
ALTER TABLE `kuerp_goods_sales_summary` MODIFY COLUMN `basic_nmber` double(15,4) DEFAULT '0.0000';
ALTER TABLE `kuerp_goods` MODIFY COLUMN `inventory` double(15,4) NOT NULL DEFAULT '0.0000';

CREATE TABLE IF NOT EXISTS `kuerp_goods_salethird` (
                                                               `id` int(11) NOT NULL AUTO_INCREMENT,
                                                               `order_num` varchar(100) DEFAULT '0' COMMENT '外部订单号',
                                                               `purchase_id` int(11) DEFAULT NULL COMMENT '销货单ID',
                                                               `third_id` int(11) DEFAULT NULL COMMENT '三方ID',
                                                               `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                               `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                               PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='三方销售订单关联';

CREATE TABLE IF NOT EXISTS `kuerp_third_account` (
                                                             `id` int(11) NOT NULL AUTO_INCREMENT,
                                                             `name` varchar(120) NOT NULL DEFAULT '' COMMENT '名称',
                                                             `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
                                                             `account` varchar(30) NOT NULL DEFAULT '' COMMENT '账号',
                                                             `salt` varchar(100) DEFAULT NULL COMMENT '秘钥',
                                                             `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
                                                             `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                             `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                             PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='接口账号表';

--
-- 1.1.4
-- 修改类型
--
ALTER TABLE `kuerp_goods_batch` MODIFY COLUMN `attribute_id` int(11) DEFAULT 0;
ALTER TABLE `kuerp_goods_batch_info` MODIFY COLUMN `attribute_id` int(11) DEFAULT 0;
ALTER TABLE `kuerp_goods_batch_stock` MODIFY COLUMN `attribute_id` int(11) DEFAULT 0;

--
-- 1.1.5
-- 添加默认演示客户
--
INSERT IGNORE INTO `kuerp_user` VALUES (1,NULL,0,'demo','demo','31b349044b2dc7669311697cd96b5286','H5VGaC','','13888888888','',1,0,NULL,'',0.00,0,24,24,1648002533,1648004570,'121.33.147.115',0,'125.67.136.35',1645760036,1645760036,1648004570,NULL,'','hidden','{\"email\":0,\"mobile\":0,\"wxMiniPrograms\":1}',1,1);
ALTER TABLE `kuerp_user` MODIFY COLUMN `group_id` int(10) unsigned NULL DEFAULT '0' COMMENT '组别ID';
ALTER TABLE `kuerp_user` MODIFY COLUMN `status` varchar(30) NULL DEFAULT 'normal' COMMENT '状态';

--
-- 1.1.6
-- 完善对外接口
--
INSERT IGNORE INTO `kuerp_user_config` (`id`,`admin_id`,`name`,`group`,`title`,`tip`,`type`,`value`,`content`,`rule`,`extend`,`setting`) VALUES
(8,NULL,'price_status','','是否显示价格','','','1',NULL,'','',''),
(9,NULL,'speed','','滚动速度','','','30',NULL,'','','');

ALTER TABLE `kuerp_customers` ADD COLUMN `third_id` int(11) DEFAULT 0 COMMENT '三方ID' AFTER `account_time`;
ALTER TABLE `kuerp_customers` ADD COLUMN `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态' AFTER `third_id`;
ALTER TABLE `kuerp_goods_sales` ADD COLUMN `third_id` int(11) DEFAULT 0 COMMENT '三方ID' AFTER `cost_data`;
ALTER TABLE `kuerp_goods_sales_exchange` ADD COLUMN `third_id` int(11) DEFAULT 0 COMMENT '三方ID' AFTER `cost_data`;

CREATE TABLE IF NOT EXISTS `kuerp_goods_exchangethird` (
                                                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                                                   `order_num` varchar(100) DEFAULT '0' COMMENT '外部订单号',
                                                                   `purchase_id` int(11) DEFAULT NULL COMMENT '销货单ID',
                                                                   `third_id` int(11) DEFAULT NULL COMMENT '三方ID',
                                                                   `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                                   `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='三方销售退货单关联';

--
-- 1.1.7
-- 修复核销单，增加基础收银台功能
--
INSERT IGNORE INTO `kuerp_prefix` (`id`, `admin_id`, `type`, `name`, `prefix`, `year`, `month`, `day`, `hour`, `minute`, `second`, `start`, `strlen`, `example`, `dbname`, `field`) VALUES
(28,1,28,'零售单','POS','1','1','1','2','2','2',1,3,'POS20210925001','kuerp_goods_sales','order_code'),
(29,1,29,'零售退货单','LSTH','1','1','1','2','2','2',1,3,'LSTH20210925001','kuerp_goods_sales_exchange','order_code');
ALTER TABLE `kuerp_payment_log` MODIFY COLUMN `business_type` enum('1','2','3','4','5','6','7') DEFAULT NULL COMMENT '业务类型:1=普通采购,2=采购退回,3=付款,4=退款,5=期初应付款,6=期初预付款,7=核销';
ALTER TABLE `kuerp_sales_payment_log` MODIFY COLUMN `business_type` enum('1','2','3','4','5','6','7') DEFAULT NULL COMMENT '业务类型:1=销货,2=销货退回,3=付款,4=退款,5=期初应收款,6=期初预收款,7=核销';
ALTER TABLE `kuerp_goods_sales` ADD COLUMN `order_code` varchar(50) DEFAULT NULL COMMENT '零售编号' AFTER `purchase_code`;
ALTER TABLE `kuerp_goods_sales` ADD COLUMN `order_time` bigint(16) DEFAULT NULL COMMENT '零售时间' AFTER `order_code`;
ALTER TABLE `kuerp_goods_sales` ADD COLUMN `order_type` enum('1','2') DEFAULT '1' COMMENT '单据类型:1=销货单,2=零售单' AFTER `order_time`;
ALTER TABLE `kuerp_goods_sales_exchange` ADD COLUMN `order_code` varchar(50) DEFAULT NULL COMMENT '零售编号' AFTER `purchase_code`;
ALTER TABLE `kuerp_goods_sales_exchange` ADD COLUMN `order_time` bigint(16) DEFAULT NULL COMMENT '零售时间' AFTER `order_code`;
ALTER TABLE `kuerp_goods_sales_exchange` ADD COLUMN `order_type` enum('1','2') DEFAULT '1' COMMENT '单据类型:1=销货单,2=零售单' AFTER `order_time`;

--
-- 1.1.8
-- 优化盘点单据显示
--
ALTER TABLE `kuerp_warehouse` ADD COLUMN `order_id` int(11) DEFAULT NULL COMMENT '盘点单ID' AFTER `print_num`;
ALTER TABLE `kuerp_warehouse` ADD COLUMN `order_type` enum('1','2') DEFAULT NULL COMMENT '单据类型:1=盘点,2=序列号盘点' AFTER `order_id`;
ALTER TABLE `kuerp_warehousing` ADD COLUMN `order_id` int(11) DEFAULT NULL COMMENT '盘点单ID' AFTER `print_num`;
ALTER TABLE `kuerp_warehousing` ADD COLUMN `order_type` enum('1','2') DEFAULT NULL COMMENT '单据类型:1=盘点,2=序列号盘点' AFTER `order_id`;

--
-- 1.2.0
-- 优化退货单
--
ALTER TABLE `kuerp_goods_excpur` ADD COLUMN `type` enum('0','1','2') DEFAULT '0' COMMENT '单据类型' AFTER `purchase_id`;
ALTER TABLE `kuerp_goods_saleexc` ADD COLUMN `type` enum('0','1','2') DEFAULT '0' COMMENT '单据类型' AFTER `purchase_id`;

--
-- 1.2.2
-- 优化商品表
--
INSERT IGNORE INTO `kuerp_sets` (`id`, `admin_id`, `type`, `name`, `nickname`, `value`, `is_edit`, `notice`, `explain`, `is_checked`, `set`) VALUES
(28,1,1,'secret','小程序接口秘钥',NULL,'0',NULL,'小程序必须携带此参数才能访问小程序接口',0,NULL),
(29,1,4,'appid','小程序appid',NULL,'0',NULL,NULL,0,NULL),
(30,1,4,'appsecret','小程序秘钥',NULL,'0',NULL,NULL,0,NULL);
ALTER TABLE `kuerp_goods` MODIFY COLUMN `min_stock` decimal(15,4) DEFAULT '0.0000';
ALTER TABLE `kuerp_goods` MODIFY COLUMN `max_stock` decimal(15,4) DEFAULT '0.0000';

--
-- 1.2.3
-- 新增关联生产
--
ALTER TABLE `kuerp_goods_batch_log` MODIFY COLUMN `business_type` enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','16') DEFAULT NULL COMMENT '业务类型:1=期初余额,2=普通采购,3=采购退回,4=普通销售,5=销售退回,6=调拨单,7=盘盈,8=其他入库,9=盘亏,10=其他出库,11=组合单,12=组合单,13=拆卸单,14=拆卸单,16=生产';
ALTER TABLE `kuerp_goods_log` MODIFY COLUMN `business_type` enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','17') NOT NULL DEFAULT '1' COMMENT '业务类型:1=期初余额,2=普通采购,3=采购退回,4=普通销售,5=销售退回,6=调拨单,7=成本调整,8=盘盈,9=其他入库,10=盘亏,11=其他出库,12=组装单,13组装单,14=拆卸单,15=拆卸单,17=生产';
ALTER TABLE `kuerp_goods_serial` MODIFY COLUMN `status` enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15') DEFAULT '1' COMMENT '状态:1=购货,2=购货退货,3=销货,4=销货退货,5=盘点,6=其他,7=盘盈,8=其他入库,9=盘亏,10=其他出库,11=组合单,12=组合单,13=拆卸单,14=拆卸单,15=生产';
ALTER TABLE `kuerp_goods_serial_log` MODIFY COLUMN `business_type` enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','16') DEFAULT NULL COMMENT '业务类型:1=期初,2=普通采购,3=采购退回,4=普通销售,5=销售退回,6=调拨单,,7=盘盈,8=其他入库,9=盘亏,10=其他出库,11=组合单,12=组合单,13=拆卸单,14=拆卸单,16=生产';

--
-- 1.2.6
-- 新增订货通支付功能
--
ALTER TABLE `kuerp_goods` ADD COLUMN `promotion` enum('0','1') NULL DEFAULT '0' COMMENT '是否促销:0=否,1=是' AFTER `order_status`;
INSERT IGNORE INTO `kuerp_user_sets` (`id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`) VALUES
(3,1,'mch_id','商户号','','0',NULL,NULL,0,NULL),
(4,1,'pay_key','支付秘钥','','0','','',0,NULL),
(5,1,'template_xd','下单消息模板','','0',NULL,NULL,0,NULL),
(6,1,'template_sh','审核消息模板','','0',NULL,NULL,0,NULL),
(7,1,'template_fh','发货消息模板','','0',NULL,NULL,0,NULL);
ALTER TABLE `kuerp_user_order` ADD COLUMN `diver_type` enum('1','2') DEFAULT '1' COMMENT '配送类型:1=专业配送,2=到店自取' AFTER `pay_time`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `store_id` int(11) DEFAULT NULL COMMENT '门店ID' AFTER `diver_type`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `diver_id` int(11) DEFAULT NULL COMMENT '司机ID' AFTER `store_id`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `diver_name` varchar(255) DEFAULT NULL COMMENT '司机姓名' AFTER `diver_id`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `diver_phone` varchar(100) DEFAULT NULL COMMENT '司机电话' AFTER `diver_name`;
CREATE TABLE IF NOT EXISTS `kuerp_config` (
                                                      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
                                                      `admin_id` int(11) DEFAULT NULL,
                                                      `name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量名',
                                                      `group` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '分组',
                                                      `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量标题',
                                                      `tip` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量描述',
                                                      `type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '类型:string,text,int,bool,array,datetime,date,file',
                                                      `value` text COLLATE utf8mb4_unicode_ci COMMENT '变量值',
                                                      `content` text COLLATE utf8mb4_unicode_ci COMMENT '变量字典数据',
                                                      `rule` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '验证规则',
                                                      `extend` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '扩展属性',
                                                      `setting` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '配置',
                                                      PRIMARY KEY (`id`),
                                                      UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='系统配置';
INSERT IGNORE INTO `kuerp_config` VALUES
(1,NULL,'version','','','','','1.0.0',NULL,'','',''),
(2,NULL,'agreement','','','','','用户协议',NULL,'','',''),
(3,NULL,'privacy','','','','','隐私协议',NULL,'','',''),
(4,NULL,'share_img','','','','','/uploads/20220120/80411b8473afcdd8814851e781a41442.png',NULL,'','',''),
(5,NULL,'stock_tips','','','','','<p>
	<strong><span style="font-size:14px;">1.</span></strong><span style="font-size:14px;">可用库存的取值逻辑是取单据新增时选择商品+仓库的可用库存,取出来之后会进行保存,后期</span><span style="color:#E53333;font-size:14px;">不会随着商品的库存变化而自动发生变化,如需查看库存请点击仓库前面的放大镜按钮查看</span><br />
<strong><span style="font-size:14px;">2</span></strong><span style="font-size:14px;">.举例:商品a在仓库a的即时库存10,可用库存9</span><br />
<span style="font-size:14px;">&nbsp;&nbsp;</span><strong><span style="font-size:14px;">1)</span></strong><span style="font-size:14px;">新增销货单,选择商品a和仓库a,可用库存显示的是9,单据保存</span><br />
<span style="font-size:14px;">&nbsp;&nbsp;</span><strong><span style="font-size:14px;">2)</span></strong><span style="font-size:14px;">新增购货单选择商品a和仓库a,入库数量10,单据审核</span><br />
<span style="font-size:14px;">&nbsp;&nbsp;</span><strong><span style="font-size:14px;">3)</span></strong><span style="font-size:14px;">找到刚刚保存的销货单,查看商品a和仓库a的可用库存显示是9,请注意这里不会是19,因为可用库存不会重新获取。</span>
</p>',NULL,'','','');
INSERT IGNORE INTO `kuerp_user_config` (`id`,`admin_id`,`name`,`group`,`title`,`tip`,`type`,`value`,`content`,`rule`,`extend`,`setting`) VALUES
(10,NULL,'pay_status','','开启在线支付','','','0',NULL,'','','');
CREATE TABLE IF NOT EXISTS `kuerp_user_applet` (
                                                           `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
                                                           `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
                                                           `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '组名',
                                                           `rules` text COLLATE utf8mb4_unicode_ci COMMENT '权限节点',
                                                           `applet` text COLLATE utf8mb4_unicode_ci COMMENT '小程序规则',
                                                           `createtime` bigint(16) DEFAULT NULL COMMENT '添加时间',
                                                           `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                           `status` enum('normal','hidden') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态',
                                                           `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
                                                           PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员常用设置表';
CREATE TABLE IF NOT EXISTS `kuerp_driver` (
                                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                                      `admin_id` int(11) DEFAULT NULL,
                                                      `name` varchar(100) DEFAULT NULL COMMENT '名称',
                                                      `phone` varchar(20) DEFAULT NULL COMMENT '电话',
                                                      `plate` varchar(100) DEFAULT NULL COMMENT '车牌号',
                                                      `status` enum('0','1') DEFAULT '1' COMMENT '状态:0=禁用,1=正常',
                                                      `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
                                                      `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
                                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='司机表';

--
-- 1.3.6
-- 优化状态
--
ALTER TABLE `kuerp_accounts` ADD `status` enum('0','1') DEFAULT '1' COMMENT '状态:0=关闭,1=正常' AFTER `is_default`;
ALTER TABLE `kuerp_customers` MODIFY COLUMN `status` enum('0','1') NOT NULL DEFAULT '1' COMMENT '状态';

--
-- 1.6.1
-- 添加订货单模块
--

ALTER TABLE `kuerp_user_order` ADD COLUMN `numb` int(11) DEFAULT 1 COMMENT '当月序号' AFTER `deletetime`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `goods_images` text DEFAULT null COMMENT '附件' AFTER `numb`;

--
-- 1.6.10
-- 添加订货单发货同步模块，更新时间类型
--

ALTER TABLE `kuerp_user_order` ADD COLUMN `express_code` varchar(20) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '快递公司编号' AFTER `deletetime`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `express_name` varchar(255) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '快递公司名称' AFTER `express_code`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `express_num` varchar(100) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '快递单号' AFTER `express_name`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `pay_info` text CHARACTER SET utf8 NULL COMMENT '支付信息' AFTER `express_num`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `send_code` varchar(255) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '同步状态码' AFTER `pay_info`;
ALTER TABLE `kuerp_user_order` ADD COLUMN `send_msg` varchar(255) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '同步信息' AFTER `send_code`;

INSERT IGNORE INTO `kuerp_user_config` (`id`,`admin_id`,`name`,`group`,`title`,`tip`,`type`,`value`,`content`,`rule`,`extend`,`setting`) VALUES
(11, NULL, 'order_send', '', '同步发货信息', '', '4', '0', NULL, '', '', '');
INSERT IGNORE INTO `kuerp_user_config` (`id`,`admin_id`,`name`,`group`,`title`,`tip`,`type`,`value`,`content`,`rule`,`extend`,`setting`) VALUES
(12, NULL, 'order_send_name', '', '发货人名称', '', '4', '', NULL, '', '', '');
INSERT IGNORE INTO `kuerp_user_config` (`id`,`admin_id`,`name`,`group`,`title`,`tip`,`type`,`value`,`content`,`rule`,`extend`,`setting`) VALUES
(13, NULL, 'order_send_phone', '', '发货人电话', '', '4', '', NULL, '', '', '');

ALTER TABLE `kuerp_accounts` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_accounts` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_accounts` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_accounts_copewith` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `suppliers_id`;
ALTER TABLE `kuerp_accounts_copewith` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `real_money`;
ALTER TABLE `kuerp_accounts_copewith` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_accounts_log` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `remark`;
ALTER TABLE `kuerp_accounts_log` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_accounts_log` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_accounts_receivable` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `customers_id`;
ALTER TABLE `kuerp_accounts_receivable` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `real_money`;
ALTER TABLE `kuerp_accounts_receivable` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_accounts_transfer` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_accounts_transfer` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_accounts_transfer` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `pay_status`;
ALTER TABLE `kuerp_accounts_transfer` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_accounts_transfer_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_id`;
ALTER TABLE `kuerp_accounts_transfer_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `remark`;
ALTER TABLE `kuerp_accounts_transfer_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_address` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `is_default`;
ALTER TABLE `kuerp_address` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_adjustment` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_adjustment` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_adjustment` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_adjustment_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_adjustment_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `remark`;
ALTER TABLE `kuerp_adjustment_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_allocation` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_allocation` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_allocation` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_allocation` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_assemble` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_assemble` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_assemble` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_assemble` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_assemble_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_assemble_info` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_assemble_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_assemble_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_assemble_info_temp` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_assemble_info_temp` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_assemble_info_temp` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_assemble_info_temp` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_assemble_temp` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_assemble_temp` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_assemble_temp` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_assemble_temp` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_attr_combination` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `attr_code`;
ALTER TABLE `kuerp_attr_combination` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_attribute` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `name`;
ALTER TABLE `kuerp_attribute` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_aux_combination` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `attr_code`;
ALTER TABLE `kuerp_aux_combination` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_auxiliary` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_auxiliary` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_banner` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_banner` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_banner_type` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_banner_type` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_checkout` MODIFY COLUMN `checktime` bigint(16) NULL DEFAULT NULL COMMENT '结账日期' AFTER `checkdate`;
ALTER TABLE `kuerp_checkout` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `preparation_time`;
ALTER TABLE `kuerp_checkout` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_checkout_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_id`;
ALTER TABLE `kuerp_collection` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_collection` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `operation_id`;
ALTER TABLE `kuerp_collection` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_collection` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_collection_account` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_collection_sale` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_cost` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_cost` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_cost` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `pay_status`;
ALTER TABLE `kuerp_cost` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_customer_goodscoding` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `customer_code`;
ALTER TABLE `kuerp_customer_goodscoding` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_customers` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_customers` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_customers_user` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_customers_user` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_customers_user` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_driver` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_driver` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_enclosure` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `upload_date`;
ALTER TABLE `kuerp_enclosure` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_expend_type` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `path`;
ALTER TABLE `kuerp_expend_type` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_expenditure` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_expenditure` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_expenditure` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `pay_status`;
ALTER TABLE `kuerp_expenditure` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_expenditure_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_id`;
ALTER TABLE `kuerp_expenditure_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `cost_id`;
ALTER TABLE `kuerp_expenditure_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `promotion`;
ALTER TABLE `kuerp_goods` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_goods_attr` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `purchase`;
ALTER TABLE `kuerp_goods_attr` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_batch` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `production`;
ALTER TABLE `kuerp_goods_batch` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_batch_exchange_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `type`;
ALTER TABLE `kuerp_goods_batch_exchange_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_batch_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `type`;
ALTER TABLE `kuerp_goods_batch_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_batch_log` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_goods_batch_log` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `order_id`;
ALTER TABLE `kuerp_goods_batch_log` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_batch_sale_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `type`;
ALTER TABLE `kuerp_goods_batch_sale_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_batch_salee_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `type`;
ALTER TABLE `kuerp_goods_batch_salee_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_batch_stock` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_goods_batch_stock` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_exchange` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_exchange` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_exchange` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `cost_data`;
ALTER TABLE `kuerp_goods_exchange` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_exchange_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_exchange_info` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_exchange_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `period`;
ALTER TABLE `kuerp_goods_exchange_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_exchangethird` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `third_id`;
ALTER TABLE `kuerp_goods_exchangethird` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_log` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_id`;
ALTER TABLE `kuerp_goods_log` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `balance_cost`;
ALTER TABLE `kuerp_goods_log` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_period` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `production`;
ALTER TABLE `kuerp_goods_period` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_period` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_goods_price` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `is_default`;
ALTER TABLE `kuerp_goods_price` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_price` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_goods_purchase` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_purchase` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_purchase` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `cost_data`;
ALTER TABLE `kuerp_goods_purchase` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_purchase_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_purchase_info` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_purchase_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `period`;
ALTER TABLE `kuerp_goods_purchase_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_purchase_order` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_purchase_order` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_purchase_order` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_goods_purchase_order` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_purchase_order_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_purchase_order_info` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_purchase_order_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `library_time`;
ALTER TABLE `kuerp_goods_purchase_order_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_purchase_summary` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_purchase_summary` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_purchase_summary` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `period`;
ALTER TABLE `kuerp_goods_purchase_summary` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_sales` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_sales` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_sales` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `third_id`;
ALTER TABLE `kuerp_goods_sales` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_sales_exchange` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_sales_exchange` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_sales_exchange` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `third_id`;
ALTER TABLE `kuerp_goods_sales_exchange` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_sales_exchange_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_sales_exchange_info` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_sales_exchange_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `period`;
ALTER TABLE `kuerp_goods_sales_exchange_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_sales_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_sales_info` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_sales_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `period`;
ALTER TABLE `kuerp_goods_sales_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_sales_order` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_sales_order` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_sales_order` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_goods_sales_order` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_sales_order_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_sales_order_info` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_sales_order_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `library_time`;
ALTER TABLE `kuerp_goods_sales_order_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_sales_profit` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `admin_id`;
ALTER TABLE `kuerp_goods_sales_summary` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_goods_sales_summary` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_goods_sales_summary` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `period`;
ALTER TABLE `kuerp_goods_sales_summary` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_salethird` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `third_id`;
ALTER TABLE `kuerp_goods_salethird` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_serial` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `old_store`;
ALTER TABLE `kuerp_goods_serial` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_serial_log` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_goods_serial_log` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `order_id`;
ALTER TABLE `kuerp_goods_serial_log` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_stock` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `cost_money`;
ALTER TABLE `kuerp_goods_stock` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_stock` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_goods_stock_warning` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `max_stock`;
ALTER TABLE `kuerp_goods_stock_warning` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_goods_store_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `all_money`;
ALTER TABLE `kuerp_goods_type` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `order_status`;
ALTER TABLE `kuerp_goods_type` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_income` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_income` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_income` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `pay_status`;
ALTER TABLE `kuerp_income` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_income_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_id`;
ALTER TABLE `kuerp_income_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `remark`;
ALTER TABLE `kuerp_income_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_income_type` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `path`;
ALTER TABLE `kuerp_income_type` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_inventory` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_inventory` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `result`;
ALTER TABLE `kuerp_inventory` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_inventory_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_inventory_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `profit`;
ALTER TABLE `kuerp_inventory_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_inventory_serial` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_inventory_serial` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `result`;
ALTER TABLE `kuerp_inventory_serial` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_inventory_serial_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_inventory_serial_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `loss`;
ALTER TABLE `kuerp_inventory_serial_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_invoicing` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `invoice_status`;
ALTER TABLE `kuerp_invoicing_log` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `give_money`;
ALTER TABLE `kuerp_payment` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_payment` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `operation_id`;
ALTER TABLE `kuerp_payment` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_payment` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_payment_account` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_payment_log` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `reamrk`;
ALTER TABLE `kuerp_payment_sale` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_sales_invoicing` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `invoice_status`;
ALTER TABLE `kuerp_sales_invoicing_log` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `give_money`;
ALTER TABLE `kuerp_sales_payment_log` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `reamrk`;
ALTER TABLE `kuerp_settlementtype` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_settlementtype` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_settlementtype` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_split` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_split` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_split` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_split` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_split_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_split_info` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_split_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_split_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_split_info_temp` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_split_info_temp` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_split_info_temp` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_split_info_temp` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_split_temp` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_split_temp` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `examine_status`;
ALTER TABLE `kuerp_split_temp` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_split_temp` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_staff_member` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_staff_member` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_stores` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_stores` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_suppliers` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_suppliers` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_suppliers_user` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_suppliers_user` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_suppliers_user` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_supplyertype` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `weigh`;
ALTER TABLE `kuerp_supplyertype` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_third_account` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_third_account` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_transfers` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `goodsnote`;
ALTER TABLE `kuerp_transfers` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_transfers` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_unit` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `is_main`;
ALTER TABLE `kuerp_unit` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_unit_conversion` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `advance_rate`;
ALTER TABLE `kuerp_unit_conversion` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_user` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `jointime`;
ALTER TABLE `kuerp_user` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_user` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_user_address` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `is_default`;
ALTER TABLE `kuerp_user_address` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_user_applet` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `applet`;
ALTER TABLE `kuerp_user_applet` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_user_cart` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `number`;
ALTER TABLE `kuerp_user_cart` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_user_history` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `look_date`;
ALTER TABLE `kuerp_user_history` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_user_oauth` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `access_token`;
ALTER TABLE `kuerp_user_oauth` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_user_order` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `diver_phone`;
ALTER TABLE `kuerp_user_order` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_user_order` MODIFY COLUMN `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间' AFTER `updatetime`;
ALTER TABLE `kuerp_user_orderinfo` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `money`;
ALTER TABLE `kuerp_user_orderinfo` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_warehouse` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_warehouse` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `operation_id`;
ALTER TABLE `kuerp_warehouse` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `order_type`;
ALTER TABLE `kuerp_warehouse` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_warehouse_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_warehouse_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `validity`;
ALTER TABLE `kuerp_warehouse_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_warehousing` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_warehousing` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `operation_id`;
ALTER TABLE `kuerp_warehousing` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `order_type`;
ALTER TABLE `kuerp_warehousing` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_warehousing_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_warehousing_info` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `validity`;
ALTER TABLE `kuerp_warehousing_info` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_writeoff` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_writeoff` MODIFY COLUMN `examine_time` bigint(16) NULL DEFAULT NULL AFTER `operation_id`;
ALTER TABLE `kuerp_writeoff` MODIFY COLUMN `createtime` bigint(16) NULL DEFAULT NULL AFTER `print_num`;
ALTER TABLE `kuerp_writeoff` MODIFY COLUMN `updatetime` bigint(16) NULL DEFAULT NULL AFTER `createtime`;
ALTER TABLE `kuerp_writeoff_info` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_type`;
ALTER TABLE `kuerp_writeoff_source` MODIFY COLUMN `purchase_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_code`;
ALTER TABLE `kuerp_accounts_log` MODIFY COLUMN `pay_time` bigint(16) NULL DEFAULT NULL AFTER `expenditure`;
ALTER TABLE `kuerp_user_order` MODIFY COLUMN `pay_time` bigint(16) NULL DEFAULT NULL AFTER `pay_status`;
ALTER TABLE `kuerp_customers` MODIFY COLUMN `account_time` bigint(16) NULL DEFAULT NULL AFTER `staff_member_id`;
ALTER TABLE `kuerp_suppliers` MODIFY COLUMN `account_time` bigint(16) NULL DEFAULT NULL AFTER `receive_account`;
ALTER TABLE `kuerp_goods_exchange` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_exchange_info` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_purchase_info` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_purchase` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_purchase_order` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_purchase_order_info` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_purchase_summary` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_sales` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_sales_exchange` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_sales_exchange_info` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_sales_info` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_sales_order` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_sales_order_info` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_sales_summary` MODIFY COLUMN `delivery_time` bigint(16) NULL DEFAULT NULL AFTER `purchase_time`;
ALTER TABLE `kuerp_goods_purchase_order_info` MODIFY COLUMN `library_time` bigint(16) NULL DEFAULT NULL AFTER `library_money`;
ALTER TABLE `kuerp_goods_sales_order_info` MODIFY COLUMN `library_time` bigint(16) NULL DEFAULT NULL AFTER `library_money`;
ALTER TABLE `kuerp_goods_sales` MODIFY COLUMN `order_time` bigint(16) NULL DEFAULT NULL AFTER `order_code`;

--
-- 1.6.11
-- 更新时间类型
--

ALTER TABLE `kuerp_invoicing` MODIFY COLUMN `bill_time` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_invoicing_log` MODIFY COLUMN `bill_time` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_payment_log` MODIFY COLUMN `bill_time` bigint(16) NULL DEFAULT NULL AFTER `business_type`;
ALTER TABLE `kuerp_sales_invoicing` MODIFY COLUMN `bill_time` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_sales_invoicing_log` MODIFY COLUMN `bill_time` bigint(16) NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `kuerp_sales_payment_log` MODIFY COLUMN `bill_time` bigint(16) NULL DEFAULT NULL AFTER `business_type`;
ALTER TABLE `kuerp_checkout` MODIFY COLUMN `checktime` bigint(16) NULL DEFAULT NULL AFTER `checkdate`;
ALTER TABLE `kuerp_user` MODIFY COLUMN `prevtime` bigint(16) NULL DEFAULT NULL AFTER `maxsuccessions`;
ALTER TABLE `kuerp_user` MODIFY COLUMN `logintime` bigint(16) NULL DEFAULT NULL AFTER `prevtime`;
ALTER TABLE `kuerp_user` MODIFY COLUMN `jointime` bigint(16) NULL DEFAULT NULL AFTER `joinip`;
ALTER TABLE `kuerp_user_oauth` MODIFY COLUMN `logintime` bigint(16) NULL DEFAULT NULL AFTER `expire_in`;
ALTER TABLE `kuerp_user_oauth` MODIFY COLUMN `expiretime` bigint(16) NULL DEFAULT NULL AFTER `expire_in`;
ALTER TABLE `kuerp_checkout` MODIFY COLUMN `preparation_time` bigint(16) NULL DEFAULT NULL AFTER `preparation_id`;
