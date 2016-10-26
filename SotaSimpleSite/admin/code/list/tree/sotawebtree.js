function SotaTreeNode(id, pid, text, url, title, target, icon, tree, load, noselect)
{
	this.id = id;
	this.pid = pid;
	this.text = text ? text : 'ID: ' + id;
	this.url = url;
	this.title = title;
	this.target = target;
	this.icon = icon;
	this._isOpen = false;

function SotaTree(clientID)
{
	this.config = 
		root				: 'img/globe.gif',
		folder			    : 'img/folder.gif',
		folderOpen	        : 'img/folderopen.gif',
		node				: 'img/page.gif',
		empty				: 'img/empty.gif',
		line				: 'img/line.gif',
		join				: 'img/join.gif',
		joinBottom	        : 'img/joinbottom.gif',
		plus				: 'img/plus.gif',
		plusBottom	        : 'img/plusbottom.gif',
		minus				: 'img/minus.gif',
		minusBottom	        : 'img/minusbottom.gif'
	};
	this.clientID = clientID;
	this.root.tree = this;
	this.nodesByID = {};
	this.nodesByID[-1] = this.root;
	this.onClick = null;

SotaTree.prototype.add = function(id, pid, text, url, title, target, icon, load) 