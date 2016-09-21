package com.amarsoft.app.als.sys.widget;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.amarsoft.app.als.sys.tools.CodeGenerater;
import com.amarsoft.app.als.sys.tools.ToolBox;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASObjectModel;
import com.amarsoft.awe.dw.ASObjectWindow;
import com.amarsoft.awe.util.ObjectConverts;

public class DoNoObject  implements Serializable {

	private String dono="";
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	List<Object> lst=new ArrayList<Object>();
	List<Object> resultLst=new ArrayList<Object>();
	Map<String,Object> map=new HashMap<String,Object>();
	Map<String,Object> defaultMap=new HashMap<String,Object>();
	String[] filedArray={"colHeader","colReadOnly","colname","colIndex","ColEditStyle","colCheckFormat","colEditSourceType","ColEditSource","ColHtmlStyle"};
	public DoNoObject(String sTempletNo) throws Exception{
		dono=sTempletNo;
		initByDono();
	}
	/**
	 * 通过以后模板生成数据
	 * @param dwTemp
	 * @throws ClassNotFoundException 
	 * @throws IOException 
	 */
	public DoNoObject(ASObjectWindow dwTemp) throws  Exception{
		dono=dwTemp.getDataObject().getDONO();
		Vector<ASColumn> vlst=dwTemp.getDataObject().Columns;
		initByColumn(vlst);
		String[] resultArray=dwTemp.getSerializedJBOs();
		if(resultArray == null)
			return;
		for(String str:resultArray){
			BizObject bo=(BizObject)ObjectConverts.getObject(str);
			Map<String,Object> valueMap=ToolBox.getContext(bo);
			Map<String,Object> result = new HashMap<String, Object>();
			for(String  s : valueMap.keySet()){
				result.put(s.toUpperCase(), valueMap.get(s));
			}
			resultLst.add(result);
		}
	}
	
	private void initByDono() throws Exception{
		ASDataObject doTemp = new ASDataObject(dono);
		ASObjectModel doModel; 
		Vector<ASColumn> vlst;
		int icolCount= doTemp.Columns.size();
		if(icolCount==0){
			 doModel=new ASObjectModel(dono);
			 icolCount=doModel.Columns.size();
			 vlst=doModel.Columns;
		}else{
			vlst=doTemp.Columns;
		}
		initByColumn(vlst);
	}
	
	public void initByColumn(Vector<ASColumn>  vlst){
		for(int iIndex=0;iIndex<vlst.size();iIndex++){
			ASColumn  col=vlst.get(iIndex);
			Map<String,Object> map=new HashMap<String,Object>();
			for(int i=0;i<filedArray.length;i++){
				map.put(filedArray[i],col.getAttribute(filedArray[i]));
			}
			String colEditSource=col.getAttribute("colEditSource");
			String colEditSourceType=col.getAttribute("colEditSourceType");
			if( "code".equalsIgnoreCase(colEditSourceType)){
				Map<String, Object>  codeMap=CodeGenerater.genCode(colEditSource);
				map.put("colEditSource", codeMap);
			}
			defaultMap.put(col.getAttribute("colname"), "");
			lst.add(map);
		}
	}

	
	public String toJSONString() {
		map.put("info", lst);
		if(resultLst.size()==0) resultLst.add(this.defaultMap);//无数据是填充默认值
		map.put("data", resultLst);
		String jsonStr=JSONEncoder.encode(map);
		return jsonStr;
	}

}
