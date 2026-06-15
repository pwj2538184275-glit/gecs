extends Component
## 物品栏组件
class_name C_Inventory

## 背包容量（可选）
@export var size:int = 10
## 最大重量（可选）
@export var max_weight:float
## 关系索引（必须）
@export var back_pack:Dictionary
