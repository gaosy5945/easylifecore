	//ѡ����Ʒ�ͺ�,�����ƷƷ��Ϊ�գ���չʾ���е���Ʒ�ͺţ������Ʒ�ͺŲ�Ϊ�գ��͸�����ƷƷ��չʾ����ͺ� 
	function selectXMLMerchandiseBrandModel(){
		var brand = getItemValue(0,getRow(),'MERCHANDISEBRAND');
		if(typeof(brand)=="undefined" || brand==null || brand.length==0){
			AsCredit.setJavaMethodTree('com.amarsoft.app.als.ui.treeview.XMLDataTree',{'XMLFile':'{$ARE.PRD_HOME}/etc/app/merchandise-config.xml','XMLTags':'merchandiseBrand//merchandise','Keys':'ID','ID':'ID','Name':'NAME','SortNo':'ID','SelectedValues':getItemValue(0,getRow(),'BRANDMODEL')},0,0,'BRANDMODEL','BRANDMODELNAME','N');
			var brandmodel = getItemValue(0,getRow(),'BRANDMODEL');
			setItemValue(0,0,"MERCHANDISEBRAND",brandmodel.split("-")[0]);
			setItemValue(0,0,"MERCHANDISEBRANDNAME",brandmodel.split("-")[0]);
		}else
			AsCredit.setJavaMethodTree('com.amarsoft.app.als.ui.treeview.XMLDataTree',{'XMLFile':'{$ARE.PRD_HOME}/etc/app/merchandise-config.xml','XMLTags':'merchandiseBrand||ID=\''+brand+'\'//merchandise','Keys':'ID','ID':'ID','Name':'NAME','SortNo':'ID','SelectedValues':getItemValue(0,getRow(),'BRANDMODEL')},0,0,'BRANDMODEL','BRANDMODELNAME','N');
	}
	
	//ѡ����ƷƷ�ƣ�����Ѿ�ѡ������Ʒ�ͺţ���ô�ͽ���Ʒ�ͺ����
	function selectXMLMerchandiseBrand(){
		AsCredit.setJavaMethodTree('com.amarsoft.app.als.ui.treeview.XMLDataTree',{'XMLFile':'{$ARE.PRD_HOME}/etc/app/merchandise-config.xml','XMLTags':'merchandiseBrand','Keys':'ID','ID':'ID','Name':'NAME','SortNo':'ID','SelectedValues':getItemValue(0,getRow(),'BRANDMODEL')},0,0,'MERCHANDISEBRAND','MERCHANDISEBRANDNAME','N');
	}
