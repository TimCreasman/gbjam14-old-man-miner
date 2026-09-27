@abstract
# TODO: This should inherit from Node2D but tile relies on its root being StaticBody2D
class_name OMM_PooledStaticBody2D extends StaticBody2D

## Emitted by the object to indicate to the object pooler to pool this object
signal pool_me(body: Node2D)

@abstract func reset_properties(properties: Dictionary) -> void
