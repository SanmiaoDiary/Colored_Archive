extends Node

var all_characters = {#储存所有角色信息的字典
	"ColoredArchive.cat":{#角色的id，第一位表示所属的学校，0表示是测试角色
		"name":"cat",
		"school":"",
		"speed":150,
		"hp":200,
		"icon":"res://assets/images/cat.png",#角色图标/头像（在角色列表中显示的角色缩略图）
		"texture":"res://assets/images/cat.png",#角色贴图（在游戏中显示的角色主体形象）
		},#嵌套字典保存单个角色的数据
	"ColoredArchive.Sunaookami Shiroko":{
		"name":"Sunaookami Shiroko",
		"school":"ABYDOS",
		"speed":160,
		"hp":260,
		"icon":"",
		"texture":"",
		},
	}

var all_strategic_deployment = {#保存所有的战略配备的字典
	"ColoredArchive.reinforcements":{#键格式：这个战略配备的拥有者（原版ColoredArchive或者其他mod的名称）.战略配备名称
		"name":"reinforcements",#呼叫增援
		"cd":160,
		"icon":"res://assets/images/reinforcements.png"
	},
	"ColoredArchive.resupply":{
		"name":"resupply",#呼叫补给
		"cd":160,
		"icon":"res://assets/images/reinforcements.png"
	},
	"ColoredArchive.mg-43":{
		"name":"mg-43",#机枪
		"cd":160,
		"icon":"res://assets/images/reinforcements.png"
	},
	"ColoredArchive.fast_resupply":{
		"name":"fast_resupply",
		"cd":90,
		"icon":"res://assets/images/reinforcements.png"
	},#快速补给
	"ColoredArchive.mk-2":{
		"name":"mk-2",
		"cd":90,
		"icon":"res://assets/images/reinforcements.png"
	},
	"ColoredArchive.L118":{
		"name":"L118",
		"cd":90,
		"icon":"res://assets/images/reinforcements.png"
	},#
	
}
