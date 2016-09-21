package com.amarsoft.app.als.project;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.dict.als.manage.CodeManager;

public class SelectProjectName {
	//ȡ����Ŀ����
	public static String getProjectName(String ObjectNo) throws Exception
	{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		BizObjectQuery boq = bm.createQuery("SerialNo=:SerialNo"); 
		boq.setParameter("SerialNo", ObjectNo);
		BizObject bo = boq.getSingleResult(false);
		String ProjectName="";
		if(bo!=null)
		{
			ProjectName = bo.getAttribute("ProjectName").getString();
		}
		return ProjectName;
	}
	
	//�ж��Ƿ�Ϊ�����Ŀ������Ǳ����Ŀ��δ��������У�����Ŀ״̬��Ϊ���������
	public static String setProjectStatus(String AgreementNo,String SerialNo) throws Exception{
		
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		BizObjectQuery PAI = bm.createQuery("AgreementNo=:AgreementNo").setParameter("AgreementNo", AgreementNo);
		List<BizObject> DataLastPAI = PAI.getResultList(false);
		String ProjectStatus = "";
		int i = 0;
		if(DataLastPAI!=null){
			for(BizObject bo:DataLastPAI){
				i = i + 1;
			}
			BizObjectQuery qPBI = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", SerialNo);
			BizObject prPBI = qPBI.getSingleResult(false);
			if(prPBI != null){
				ProjectStatus = prPBI.getAttribute("Status").getString();
				if(i == 1){
					ProjectStatus = CodeManager.getItemName("ProjectStatus", ProjectStatus);
				}else{
					if("11".equals(ProjectStatus)){
						ProjectStatus = "������ύ";
					}else if("12".equals(ProjectStatus)){
						ProjectStatus = "���������";
					}else{
						ProjectStatus = CodeManager.getItemName("ProjectStatus", ProjectStatus);
					}
				}
			}
		}
		return ProjectStatus;
	}
}
