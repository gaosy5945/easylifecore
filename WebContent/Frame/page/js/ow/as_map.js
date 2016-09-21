//author:����ǿ   add on 2015-03-18
//����map
function Map(){
	this.container = {};
}

//��key-value����map��
Map.prototype.put = function(key,value){
	try{
		this.container[key] = value;
	}catch(e){
		return e;
	}
};

//����key��map��ȡ����Ӧ��value
Map.prototype.get = function(key){
	try{
		return this.container[key];
	}catch(e){
		return e;
	}
};

//�ж�map���Ƿ����ָ����key
Map.prototype.containsKey = function(key){
	try{
		for(var p in this.container){
			if(p==key) return true;
		}
		return false;
	}catch(e){
		return e;
	}
};

//�ж�map���Ƿ����ָ����value
Map.prototype.containsValue = function(value){
	try{
		for(var p in this.container){
			if(this.container[p]==value) return true;
		}
		return false;
	}catch(e){
		return e;
	}
};

//ɾ��map��ָ����key
Map.prototype.remove = function(key){
	try{
		delete this.container[key];
	}catch(e){
		return e;
	}
};

//���map
Map.prototype.clear = function(){
	try{
		delete this.container;
		this.container = {};
	}catch(e){
		return e;
	}
};

//����map�е�keyֵ����
Map.prototype.keyArray = function(){
	var keys = new Array();
	for(var p in this.container){
		keys.push(p);
	}
	return keys;
};

//����map�е�valueֵ����
Map.prototype.valueArray = function(){
	var values = new Array();
	var keys = this.keyArray();
	for(var i=0;i<keys.length;i++){
		values.push(this.container[keys[i]]);
	}
	return values;
};

//�ж�map�Ƿ�Ϊ��
Map.prototype.isEmpty = function(){
	if(this.keyArray().length==0){
		return true;
	}else{
		return false;
	}
};

//��ȡmap�Ĵ�С
Map.prototype.size = function(){
	return this.keyArray().length;
};



