#!/bin/bash
cat schema.sql > dump/restore.sql
cat procedures/insert_user.sql >> dump/restore.sql
cat procedures/insert_user_tutorcpf.sql >> dump/restore.sql
cat procedures/insert_profile.sql >> dump/restore.sql
cat procedures/add_profile_to_user.sql >> dump/restore.sql
cat procedures/insert_service.sql >> dump/restore.sql
cat procedures/add_service_to_profile.sql >> dump/restore.sql
cat procedures/add_tutor_to_user.sql >> dump/restore.sql
cat procedures/insert_patient.sql >> dump/restore.sql
cat procedures/insert_exam.sql >> dump/restore.sql
cat procedures/add_service_to_exam.sql >> dump/restore.sql
cat procedures/add_exam_request.sql >> dump/restore.sql
cat procedures/add_sample.sql >> dump/restore.sql
cat procedures/insert_log.sql >> dump/restore.sql
cat procedures/queries.sql >> dump/restore.sql
