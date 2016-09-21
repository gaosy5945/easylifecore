package com.amarsoft.app.als.sys.widget;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.sys.tools.ToolBox;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.ASObjectWindow;
import com.amarsoft.awe.util.ObjectConverts;

public class DwTempTools {

	public  static 	List<Object> getresultLst(ASObjectWindow dwTemp) throws IOException, ClassNotFoundException{
		List<Object> resultLst=new ArrayList<Object>();
		String[] resultArray=dwTemp.getSerializedJBOs();
		if(resultArray == null) return resultLst;
		for(String str:resultArray){
			BizObject bo=(BizObject)ObjectConverts.getObject(str);
			Map<String,Object> valueMap=ToolBox.getContext(bo);
			Map<String,Object> result = new HashMap<String, Object>();
			for(String  s : valueMap.keySet()){
				result.put(s.toUpperCase(), valueMap.get(s));
			}
			resultLst.add(result);
		}
		return resultLst;
	}
}
