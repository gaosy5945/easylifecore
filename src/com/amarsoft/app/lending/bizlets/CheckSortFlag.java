package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.bizobject.BusinessApply;


/*
	Author: --qfang 2011-6-11
	Tester:
	Describe: --业务品种分类三个标志的取值逻辑判断
	Input Param:
			sLiquidity: 流动资金贷款
			sFixed: 固定资产贷款
			sProject：项目融资
	Output Param:
			
	HistoryLog:
*/

/*
	*业务品种分类：
	*	流动资金贷款与固定资产贷款不存在交集。
	*	项目融资是固定资产贷款的子集。
	*	
	*	
*/

public class CheckSortFlag {
	private String IsLiquidity=null;
	private String IsFixed=null;
	private String IsProject=null;
	
	public String run() throws Exception{
		
		//定义变量：
		String sReturn = "";	
		//获取传入的参数
		String sLiquidity = this.IsLiquidity;
		String sFixed =this.IsFixed;
		String sProject = this.IsProject;
		
		if(sLiquidity == null) sLiquidity = "";
		if(sFixed == null) sFixed = "";
		if(sProject == null) sProject = "";
		
		/**
		 *以下的条件语句：列出所有错误的业务品种分类情况，给出相应的提示信息 
		 */
		//如果都为空
		if(sLiquidity.equals("") || sFixed.equals("") || sProject.equals("")){
			sReturn = "FALSE@"+"流动资金贷款、固定资产贷款、项目融资为必需字段，请选值！";
		}else if(sLiquidity.equals(BusinessApply.FLAGS_YES)){
			if(sFixed.equals(BusinessApply.FLAGS_NO)){
				if(sProject.equals(BusinessApply.FLAGS_NO)){
					sReturn = "SUCCESS@";
				}else{
					sReturn = "FALSE@"+"业务品种不能同时为流动资金贷款与项目融资！";
				}
			}else{
				sReturn = "FALSE@"+"业务品种不能同时为流动资金贷款与固定资产贷款！";
			}
		}else if(sLiquidity.equals(BusinessApply.FLAGS_NO)){
			if(sFixed.equals(BusinessApply.FLAGS_NO)){
				if(sProject.equals(BusinessApply.FLAGS_NO)){
					sReturn = "FALSE@"+"请至少选择一种类型！";
				}else{
					sReturn = "FALSE@"+"项目融资一定是固定资产贷款！";
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
