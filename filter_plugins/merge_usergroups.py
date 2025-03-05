# merge_usersgroups: merge extra groups into a user object
#
# Usage: {{ users | merge_usergroups(extra_groups }}
# with users = [{"user1": "myuser", "groups": ["bar","baz"], "other": "stuff"}]
# and extra_groups = {"foo": ["user1"}]
# result: [{"user1": "myuser", "groups": ["foo","bar","baz"], "other": "stuff"}]`
#
from __future__ import annotations
from ansible.utils.display import Display


def _merge_usergroups(users: list[dict[str, str | list[str]]],
                      extra_groups: dict[str, list[str]]) -> list[dict[str, str | list[str]]]:
    display = Display()
    display.vv(f"_merge_usergroups: arg1: {users}")
    display.vv(f"_merge_usergroups: arg2: {extra_groups}")

    # first invert the extra_groups dict to obtain a list of groups per user
    user_extra_groups = {}
    for group, group_users in extra_groups.items():
        for u in group_users:
            if u not in user_extra_groups:
                user_extra_groups[u] = []
            user_extra_groups[u].append(group)

    display.vv(f"_merge_usergroups: user_extra_groups: {user_extra_groups}")

    # then merge the extra groups into the user objects
    for user in users:
        user['groups'] = user.get('groups', []) + user_extra_groups.get(user['username'], [])

    display.vv(f"_merge_usergroups: users: {users}")

    return users


class FilterModule(object):
    @staticmethod
    def filters():
        return {
            'merge_usergroups': _merge_usergroups,
        }
