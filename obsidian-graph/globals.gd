extends Node

#region colors
var normal_color: Color = Color.html("dcddde") # default node color
var muted_color: Color = Color.html("#999") # Color for nodes that do not really exist -- this is an obsidian concept

var accent_color: Color = Color.html("#7f6df2") # purple selection color
#endregion
#region signals
signal gravity_disabled
signal node_hover(is_hovering: bool)
#endregion
