class_name OMM_UpgradeDefintion
extends OMM_Buyable

enum UPGRADE_TYPES { SPEED, MINE, JUMP, NONE = -1}

@export var upgrade_type : UPGRADE_TYPES = UPGRADE_TYPES.NONE
@export var upgrade_resource : OMM_UpgradeResource

