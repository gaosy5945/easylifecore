//����ڵ�
  	function Node(){
  		this.nodeName = "";
  		this.label  = "";
  		this.nodeType = "";
  		this.outNodes = new Array();//����ȥ��ڵ�
 		this.x=0;
  		this.y=0;
  		this.width=0;
  		this.height=0;
  		this.radii=30;
  		this.connetedCount =0;//�����Ӵ���
 	};
  //���ƽڵ�
  	Node.prototype.draw=function(context){
  		//context.fillStyle="rgba(0, 0, 255, 0.5)";;
		context.beginPath();
		//context.strokeWidth = 0;
		//context.strokeRect(this.x,this.y,this.width,this.height);
		context.arc(this.x,this.y,this.radii,0,Math.PI*2,true);
		context.closePath();
		//���ͼƬ
		var image = new Image();
		image.src = sImagePath + "/" + this.nodeType + ".gif";
		var nodex = this.x;
		var nodey = this.y;
		image.onload = function () {  
			context.drawImage(image,nodex-16,nodey-16,32,32);
        } ;
		//�������
		context.fillText(this.label,this.x+16,this.y+10);
		//context.fill();
  	};
  	Node.findNodeByName = function(nodeName,nodes){
  		for(var i=0;i<nodes.length;i++){
  			if(nodes[i].nodeName ==nodeName)
  				return nodes[i];
  		}
  		return null;
  	};
  	
  	//�����ͷ����
  	function Arrow(preNode,nextNode){
  		this.start_x=preNode.x;
  		this.start_y=preNode.y;
  		this.end_x=nextNode.x;
  		this.end_y=nextNode.y;
  		this.length=0;				//����֮��ĳ���
  		this.radii=nextNode.radii;					//Բ��İ뾶
  		this.arrow_len=10;			//��ͷ�ĳ���
  		this.color="#cecece";
  		this.rotation=0;
	};
	Arrow.prototype.draw=function(context){
		
		var dy = this.start_y - this.end_y;
		var dx = this.start_x - this.end_x;
		this.rotation=Math.atan2(dy,dx);
		if(dy == 0)
			this.length = Math.abs(dx);
		else if(dx == 0)
			this.length = Math.abs(dy);
		else
				this.length=Math.sqrt(dx*dx+dy*dy);
		
  		context.save();
  		context.translate(this.start_x,this.start_y);
  		context.rotate(this.rotation);
  		context.lineWidth=2;
  		context.fillStyle=this.color;
  		
		context.lineJoin = 'round';
		context.strokeStyle=this.color;
  		context.beginPath();
  		context.moveTo(0,0);
  		context.lineTo(0,-0);//-2
  		context.lineTo(-(this.length-this.radii-this.arrow_len),-0);//2
  		context.lineTo(-(this.length-this.radii-this.arrow_len),-3);//-4
  		context.lineTo(-(this.length-this.radii),0);
  		
  		context.lineTo(-(this.length-this.radii-this.arrow_len),3);//4
  		context.lineTo(-(this.length-this.radii-this.arrow_len),0);//2
  		context.lineTo(0,0);//2
  		context.closePath();
		context.fill();
  		context.stroke();
  		context.restore();
 	};
 	