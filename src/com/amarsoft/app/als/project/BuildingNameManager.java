package com.amarsoft.app.als.project;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class BuildingNameManager {
	
	public static String getProjectName(String REALESTATEID) throws Exception
	{
		String ProjectName = "";
		BizObjectManager bmPB=JBOFactory.getBizObjectManager("jbo.prj.PRJ_BUILDING");
		BizObjectQuery boPB = bmPB.createQuery("BuildingSerialNo=:BuildingSerialNo");
		boPB.setParameter("BuildingSerialNo", REALESTATEID);
		BizObject bo1 = boPB.getSingleResult(false);
		String ProjectSerialNo = bo1.getAttribute("ProjectSerialNo").toString();
		
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		BizObjectQuery boq = bm.createQuery("SerialNo=:SerialNo"); 
		boq.setParameter("SerialNo", ProjectSerialNo);
		BizObject bo = boq.getSingleResult(false);
		if(bo!=null)
		{
			ProjectName = bo.getAttribute("ProjectName").toString();
		}
		return ProjectName;
	}

}
