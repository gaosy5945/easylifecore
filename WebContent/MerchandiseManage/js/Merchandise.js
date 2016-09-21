	//选择商品型号,如果商品品牌为空，就展示所有的商品型号，如果商品型号不为空，就根据商品品牌展示相关型号 
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
	
	//选择商品品牌，如果已经选择了商品型号，那么就将商品型号清空
	function selectXMLMerchandiseBrand(){
		AsCredit.setJavaMethodTree('com.amarsoft.app.als.ui.treeview.XMLDataTree',{'XMLFile':'{$ARE.PRD_HOME}/etc/app/merchandise-config.xml','XMLTags':'merchandiseBrand','Keys':'ID','ID':'ID','Name':'NAME','SortNo':'ID','SelectedValues':getItemValue(0,getRow(),'BRANDMODEL')},0,0,'MERCHANDISEBRAND','MERCHANDISEBRANDNAME','N');
	}
