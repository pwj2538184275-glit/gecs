extends RefCounted
class_name ItemHelp

## 自然添加物品
static func add_item(entity:Entity,itemr:Relationship)->bool:
	if not itemr.relation is C_HasItem:
		return false
	var c_inventory = entity.get_component(C_Inventory) as C_Inventory
	if not c_inventory:
		return false
	if itemr.source and itemr.source != entity:
		var source_inventory = itemr.source.get_component(C_Inventory) as C_Inventory
		var key = remove_item(source_inventory,itemr)
		if ECS.world:
			ECS.world.item_remove.emit(itemr.source,itemr,key)
	var old_r = Relationship.new(C_HasItem.new(),{C_Item: {"name": {"_eq":itemr.target.name}}})
	var r := entity.get_relationship(old_r)
	var index
	## 原来的基础是添加
	if r and entity.name != "DroppedItems":
		index = c_inventory.back_pack.find_key(r)
		add_item_to_index(entity,c_inventory,itemr,index)
	## 添加新物品
	else:
		r = itemr
		index = add_item_to_index(entity,c_inventory,itemr)
	if ECS.world:
		ECS.world.item_add.emit(entity,r,index)
	return true

## 向索引添加物品
static func add_item_to_index(entity:Entity,c_inventory:C_Inventory,itemr:Relationship,index:int=-1)->int:
	var new_index = index
	if new_index == -1:
		new_index = c_inventory.back_pack.size()+1
	if c_inventory.back_pack.has(new_index):
		var old_item = c_inventory.back_pack[new_index].target as C_Item
		var item = itemr.target as C_Item
		if old_item.name == item.name:
			old_item.quantity += item.quantity
			return new_index
	c_inventory.back_pack[new_index] = itemr
	if entity != itemr.source:
		entity.add_relationship(itemr)
	return new_index

## 删除物品
static func remove_item(c_inventory:C_Inventory,itemr:Relationship)->int:
	var key:int = c_inventory.back_pack.find_key(itemr)
	c_inventory.back_pack.erase(key)
	itemr.source.remove_relationship(itemr)
	return key
