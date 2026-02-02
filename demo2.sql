CREATE LOGICAL SOURCE input(id UINT64, value UINT64, timestamp UINT64);
CREATE PHYSICAL SOURCE FOR input TYPE File SET('./nes-systests/testdata/small/stream8.csv' AS `SOURCE`.FILE_PATH, 'CSV' AS PARSER.`TYPE`, '\n' AS PARSER.TUPLE_DELIMITER, ',' AS PARSER.FIELD_DELIMITER);

CREATE SINK out_lp(input.id UINT64, input.value UINT64, input.timestamp UINT64) TYPE LinuxProcess SET(
  'python3 -u nes-systests/sinks/linuxprocessconsumer.py' AS `SINK`.command,
  'CSV' AS `SINK`.INPUT_FORMAT
);

SELECT id, value, timestamp
FROM input
INTO out_lp;

CREATE LOGICAL SOURCE out(id UINT64, value UINT64, timestamp UINT64);
CREATE PHYSICAL SOURCE FOR out TYPE File SET('./nes-systests/testdata/small/out-linuxprocess.csv' AS `SOURCE`.FILE_PATH, 'CSV' AS PARSER.`TYPE`, '\n' AS PARSER.TUPLE_DELIMITER, ',' AS PARSER.FIELD_DELIMITER);

CREATE SINK check(out.id UINT64, out.value UINT64, out.timestamp UINT64) TYPE File SET('./demo-output.csv' AS `SINK`.FILE_PATH, 'CSV' AS `SINK`.INPUT_FORMAT);

SELECT * FROM out INTO check;
