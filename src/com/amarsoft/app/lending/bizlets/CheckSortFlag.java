package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.bizobject.BusinessApply;


/*
	Author: --qfang 2011-6-11
	Tester:
	Describe: --ҵ��Ʒ�ַ���������־��ȡֵ�߼��ж�
	Input Param:
			sLiquidity: �����ʽ����
			sFixed: �̶��ʲ�����
			sProject����Ŀ����
	Output Param:
			
	HistoryLog:
*/

/*
	*ҵ��Ʒ�ַ��ࣺ
	*	�����ʽ������̶��ʲ�������ڽ�����
	*	��Ŀ�����ǹ̶��ʲ�������Ӽ���
	*	
	*	
*/

public class CheckSortFlag {
	private String IsLiquidity=null;
	private String IsFixed=null;
	private String IsProject=null;
	
	public String run() throws Exception{
		
		//���������
		String sReturn = "";	
		//��ȡ����Ĳ���
		String sLiquidity = this.IsLiquidity;
		String sFixed =this.IsFixed;
		String sProject = this.IsProject;
		
		if(sLiquidity == null) sLiquidity = "";
		if(sFixed == null) sFixed = "";
		if(sProject == null) sProject = "";
		
		/**
		 *���µ�������䣺�г����д����ҵ��Ʒ�ַ��������������Ӧ����ʾ��Ϣ 
		 */
		//�����Ϊ��
		if(sLiquidity.equals("") || sFixed.equals("") || sProject.equals("")){
			sReturn = "FALSE@"+"�����ʽ����̶��ʲ������Ŀ����Ϊ�����ֶΣ���ѡֵ��";
		}else if(sLiquidity.equals(BusinessApply.FLAGS_YES)){
			if(sFixed.equals(BusinessApply.FLAGS_NO)){
				if(sProject.equals(BusinessApply.FLAGS_NO)){
					sReturn = "SUCCESS@";
				}else{
					sReturn = "FALSE@"+"ҵ��Ʒ�ֲ���ͬʱΪ�����ʽ��������Ŀ���ʣ�";
				}
			}else{
				sReturn = "FALSE@"+"ҵ��Ʒ�ֲ���ͬʱΪ�����ʽ������̶��ʲ����";
			}
		}else if(sLiquidity.equals(BusinessApply.FLAGS_NO)){
			if(sFixed.equals(BusinessApply.FLAGS_NO)){
				if(sProject.equals(BusinessApply.FLAGS_NO)){
					sReturn = "FALSE@"+"������ѡ��һ�����ͣ�";
				}else{
					sReturn = "FALSE@"+"��Ŀ����һ���ǹ̶��ʲ����";
				}
			}else{
				sReturn = "SUCCESS@";
			}
		}
		return sReturn;
					
	}

	public String getIsLiquidity() {
		return IsLiquidity;
	}

	public void setIsLiquidity(String isLiquidity) {
		IsLiquidity = isLiquidity;
	}

	public String getIsFixed() {
		return IsFixed;
	}

	public void setIsFixed(String isFixed) {
		IsFixed = isFixed;
	}

	public String getIsProject() {
		return IsProject;
	}

	public void setIsProject(String isProject) {
		IsProject = isProject;
	}
}
