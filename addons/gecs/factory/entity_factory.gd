extends RefCounted
class_name EntityFactory

static func add_node_entity(node:Node,components:Array[Component],e_name:String="")->Entity:
	var world:World= node.get_tree().get_first_node_in_group("World")
	var c_node = C_Node.new(node)
	var entity := create_entity(world,components,e_name)
	entity.add_component(c_node)
	return entity

static func create_entity(world:World,components:Array[Component],e_name:String="")->Entity:
	var entity = Entity.new()
	if e_name != "":
		entity.name = e_name
	for component in components:
		entity.add_component(component)
	world.add_entity(entity)
	return entity

static func find_node_entity(node:Node2D)->Entity:
	var world:World= node.get_tree().get_first_node_in_group("World")
	var entities := world.query.with_all([C_Node]).enabled().execute()
	for entity:Entity in entities:
		var c_node = entity.get_component(C_Node) as C_Node
		if c_node.last_pos == node.global_position and c_node.node_file == node.scene_file_path:
			return entity
	return null
