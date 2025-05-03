#! /usr/bin/env python3

import argparse
import os
from datetime import datetime
from time import sleep

from ecn.util.popen import run


STD = "std"


def parse_args():
    parser = argparse.ArgumentParser(description="Environment Status Monitor")
    parser.add_argument(
        "--environments",
        "--envs",
        type=str,
        nargs="+",
        required=True,
    )
    parser.add_argument(
        "--sleep-time",
        type=int,
        default=300,  # 5 minutes
    )
    parser.add_argument("--notification-groups", type=str, nargs="+", default=["batchse", "batchse_oncall"])
    parser.add_argument(
        "--statuses",
        type=str,
        nargs="+",
        default=["failed", "unsched", "paused"],
    )
    args = parser.parse_args()
    if STD in args.notification_groups:
        args.notification_groups = ["batchse", "batchse_oncall", "batch", "data_platform"]
    return args


def _get_sql(notification_groups, statuses):
    return f"""
        SELECT
            bjs.batch_job_name,
            bjs.batch_dt,
            bjs.event_status_id,
            bjs.status,
            bjs.status_ts,
            bjs.machine_name,
            COALESCE(bjs.notification_group_name, bj.notification_group_name) AS notification_group_name
        FROM (
            SELECT
                batch_job_name,
                batch_dt,
                null as event_status_id,
                status,
                status_ts,
                machine_name,
                notification_group_name
            FROM
                batch_job_status
            WHERE
                status = ANY(ARRAY[{statuses}])
            UNION
            SELECT
                batch_job_name,
                batch_dt,
                event_status_id,
                status,
                status_ts,
                machine_name,
                notification_group_name
            FROM
                batch_job_event_status
            WHERE
                status = ANY(ARRAY[{statuses}])
            ) bjs
        LEFT OUTER JOIN
            batch_job bj
        ON
            bj.name = bjs.batch_job_name AND
            bj.data_center_name = get_location()
        WHERE
            bjs.notification_group_name = ANY(ARRAY[{notification_groups}]) OR
            bj.notification_group_name = ANY(ARRAY[{notification_groups}])
    """


def _get_cmd(environments, sql):
    return f"echo \"{sql}\" | mbsql --tight --no-dbname {' '.join(environments)}"


def get_environment_status(environments, sleep_time, notification_groups, statuses):
    sql = _get_sql(notification_groups, statuses)
    cmd = _get_cmd(environments, sql)
    while True:
        os.system("clear")
        print("----- Environment Status -----")
        print(f"Environments: {environments}")
        print(f"Notification groups: {notification_groups}")
        print(f"Time between queries: {sleep_time} seconds")
        print(f"Last Query Time: {datetime.now()}")
        stdout = run(cmd, text=True, shell=True)
        print(stdout or "\nAll Environments Clean")
        sleep(sleep_time)


def main():
    args = parse_args()
    get_environment_status(args.environments, args.sleep_time, args.notification_groups, args.statuses)


if __name__ == "__main__":
    main()
