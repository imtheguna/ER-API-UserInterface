import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

String apiTestLink = 'https://er-api-get.onrender.com/test';
//String apiERLink = 'https://er-api-get.onrender.com';
String apiERLink = 'http://127.0.0.1:5000/';
const monokaiSublimeTheme = {
  'root': TextStyle(
      backgroundColor: Colors.white, color: Colors.black, fontSize: 12),
  'tag': TextStyle(color: Color(0xfff8f8f2), fontSize: 12),
  'subst': TextStyle(color: Color(0xfff8f8f2), fontSize: 12),
  'strong': TextStyle(color: Color(0xffa8a8a2), fontWeight: FontWeight.bold),
  'emphasis': TextStyle(color: Color(0xffa8a8a2), fontStyle: FontStyle.italic),
  'bullet': TextStyle(color: Color(0xffae81ff), fontSize: 12),
  'quote': TextStyle(color: Color(0xffae81ff), fontSize: 12),
  'number': TextStyle(color: Color(0xffae81ff), fontSize: 12),
  'regexp': TextStyle(color: Color(0xffae81ff), fontSize: 12),
  'literal': TextStyle(color: Color(0xffae81ff), fontSize: 12),
  'link': TextStyle(color: Color(0xffae81ff), fontSize: 12),
  'code': TextStyle(color: Color(0xffa6e22e), fontSize: 10),
  'title': TextStyle(color: Color(0xffa6e22e), fontSize: 12),
  'section': TextStyle(color: Color(0xffa6e22e), fontSize: 12),
  'selector-class': TextStyle(color: Color(0xffa6e22e), fontSize: 12),
  'keyword': TextStyle(color: Color(0xfff92672), fontSize: 12),
  'selector-tag': TextStyle(color: Color(0xfff92672), fontSize: 12),
  'name': TextStyle(color: Color(0xfff92672), fontSize: 12),
  'attr': TextStyle(color: Color(0xfff92672), fontSize: 12),
  'symbol': TextStyle(color: Color(0xff66d9ef), fontSize: 12),
  'attribute': TextStyle(color: Color(0xff66d9ef), fontSize: 12),
  'params': TextStyle(color: Color(0xfff8f8f2), fontSize: 12),
  'string': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'type': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'built_in': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'builtin-name': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'selector-id': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'selector-attr': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'selector-pseudo': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'addition': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'variable': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'template-variable': TextStyle(color: Color(0xffe6db74), fontSize: 12),
  'comment': TextStyle(color: Color(0xff75715e), fontSize: 12),
  'deletion': TextStyle(color: Color(0xff75715e), fontSize: 12),
  'meta': TextStyle(color: Color(0xff75715e), fontSize: 12),
};

String data = '''
{
  "audit_log": {
    "columns": {
      "audit_log_key": "INT",
      "end_time": "TIMESTAMP",
      "etl_load_drvr_key": "VARCHAR",
      "impact_object": "VARCHAR",
      "process_name": "VARCHAR",
      "start_time": "TIMESTAMP",
      "status1": "VARCHAR",
      "status2": "VARCHAR",
      "status3": "VARCHAR",
      "status4": "VARCHAR",
      "status5": "VARCHAR",
      "status6": "VARCHAR",
      "status7": "VARCHAR",
      "status8": "VARCHAR",
      "status9": "VARCHAR",
      "status10": "VARCHAR",
      "status17": "VARCHAR",
      "status18": "VARCHAR"
      
    },
    "foreign_keys": {},
    "foreign_keys_len": 0
  },
  "audit_log1-audit_log1-audit_log1": {
    "columns": {
      "audit_log_key": "INT",
      "end_time": "TIMESTAMP",
      "etl_load_drvr_key": "VARCHAR",
      "impact_object": "VARCHAR",
      "process_name": "VARCHAR",
      "start_time": "TIMESTAMP",
      "status": "VARCHAR"
    },
    "foreign_keys": {},
    "foreign_keys_len": 0
  },
   "audit_log2": {
    "columns": {
      "audit_log_key": "INT",
      "end_time": "TIMESTAMP",
      "etl_load_drvr_key": "VARCHAR",
      "impact_object": "VARCHAR",
      "process_name": "VARCHAR",
      "start_time": "TIMESTAMP",
      "status": "VARCHAR"
    },
    "foreign_keys": {},
    "foreign_keys_len": 0
  },
  "dq_profile_alert_log": {
    "columns": {
      "error_record_count": "INT",
      "profile_alert_id": "INT",
      "rec_ins_ts": "TIMESTAMP",
      "rule_ds": "VARCHAR",
      "rule_id": "INT",
      "scr_run_key": "INT"
    },
    "foreign_keys": {
      "dq_rules": {
        "left_table": "dq_profile_alert_log",
        "left_table_column": ["rule_id"],
        "right_table": "dq_rules",
        "right_table_column": ["rule_id"]
      }
    },
    "foreign_keys_len": 4
  },
  "dq_row_alert_log": {
    "columns": {
      "error_record_count": "INT",
      "rec_ins_ts": "TIMESTAMP",
      "row_alert_id": "INT",
      "rule_ds": "VARCHAR",
      "rule_id": "INT",
      "scr_run_key": "INT"
    },
    "foreign_keys": {
      "dq_rules": {
        "left_table": "dq_row_alert_log",
        "left_table_column": ["rule_id"],
        "right_table": "dq_rules",
        "right_table_column": ["rule_id"]
      }
    },
    "foreign_keys_len": 4
  }, "dq_row_alert_log1": {
    "columns": {
      "error_record_count": "INT",
      "rec_ins_ts": "TIMESTAMP",
      "row_alert_id": "INT",
      "rule_ds": "VARCHAR",
      "rule_id": "INT",
      "scr_run_key": "INT"
      
    },
    "foreign_keys": {
      "dq_rules": {
        "left_table": "dq_row_alert_log",
        "left_table_column": ["rule_id"],
        "right_table": "dq_rules",
        "right_table_column": ["rule_id"]
      }
    },
    "foreign_keys_len": 4
  },
  "dq_rules": {
    "columns": {
      "rec_ins_ts": "TIMESTAMP",
      "rule_ds": "VARCHAR",
      "rule_id": "INT",
      "rule_name": "VARCHAR",
      "rule_query": "VARCHAR",
      "rule_type": "VARCHAR",
      "screen_id": "INT"
    },
    "foreign_keys": {
      "screen": {
        "left_table": "dq_rules",
        "left_table_column": ["screen_id"],
        "right_table": "screen",
        "right_table_column": ["screen_id"]
      }
    },
    "foreign_keys_len": 4
  },
  "dq_scr_run_log": {
    "columns": {
      "end_time": "TIMESTAMP",
      "error_msg": "VARCHAR",
      "rec_ins_ts": "TIMESTAMP",
      "scr_run_key": "INT",
      "screen_id": "INT",
      "start_time": "TIMESTAMP",
      "status": "VARCHAR"
    },
    "foreign_keys": {
      "screen": {
        "left_table": "dq_scr_run_log",
        "left_table_column": ["screen_id"],
        "right_table": "screen",
        "right_table_column": ["screen_id"]
      }
    },
    "foreign_keys_len": 4
  },
 
  "screen": {
    "columns": {
      "email": "VARCHAR",
      "error_bucket": "JSON",
      "filename": "VARCHAR",
      "rec_ins_ts": "TIMESTAMP",
      "screen_ds": "VARCHAR",
      "screen_id": "INT",
      "screen_name": "VARCHAR"
    },
    "foreign_keys": {},
    "foreign_keys_len": 0
  }
}
''';
