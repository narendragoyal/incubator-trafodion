--
-- @@@ START COPYRIGHT @@@
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--   http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing,
-- software distributed under the License is distributed on an
-- "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
-- KIND, either express or implied.  See the License for the
-- specific language governing permissions and limitations
-- under the License.
--
-- @@@ END COPYRIGHT @@@
--

-- set param ?filter 'UNMONITORED_QUERIES=30';  -- 30 seconds
set param ?lsq  ' sqlSrc: ';

select current_timestamp "CURRENT_TIMESTAMP"  -- (1) Now  
      ,cast(tokenstr('lastActivity:', variable_info)             -- (2) Last Activity
             as NUMERIC(18) ) LAST_ACTIVITY_SECS
      , cast(tokenstr('queryType:', variable_info)            -- (3) Query Type
            as char(30)) QUERY_TYPE
      , cast(tokenstr('subqueryType:', variable_info)            -- (4) Query SubType
            as char(30)) QUERY_SUBTYPE
      , cast(tokenstr('StatsType:', variable_info)            -- (5) Query StatsType
            as char(30)) AS QUERY_STATS_TYPE 
      , cast(tokenstr('Qid:', variable_info)            -- (6) QID
            as varchar(175) CHARACTER SET UCS2) QUERY_ID
      , cast(substr(variable_info,            -- (7) SQL Source
             position(?lsq in variable_info) + char_length(?lsq),
             char_length(variable_info) - 
                       ( position(?lsq in variable_info) + char_length(?lsq) ))
            as char(256) CHARACTER SET UCS2) SOURCE_TEXT 
from table (statistics(NULL,?filter)) 
order by 2 descending;
