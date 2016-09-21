package com.amarsoft.app.base.businessobject;

import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import com.amarsoft.app.base.antlr.OQLParser;
import com.amarsoft.app.base.antlr.OQLParser.LogicalLengthContext;
import com.amarsoft.app.base.antlr.OQLParser.LogicalMonthContext;
import com.amarsoft.app.base.antlr.OQLVisitor;
import com.amarsoft.app.base.antlr.OQLParser.AddSubContext;
import com.amarsoft.app.base.antlr.OQLParser.ArrayExprContext;
import com.amarsoft.app.base.antlr.OQLParser.AttributeContext;
import com.amarsoft.app.base.antlr.OQLParser.Equality_expressionContext;
import com.amarsoft.app.base.antlr.OQLParser.LogicalAndOrContext;
import com.amarsoft.app.base.antlr.OQLParser.LogicalCompareContext;
import com.amarsoft.app.base.antlr.OQLParser.LogicalFalseContext;
import com.amarsoft.app.base.antlr.OQLParser.LogicalInContext;
import com.amarsoft.app.base.antlr.OQLParser.LogicalTrueContext;
import com.amarsoft.app.base.antlr.OQLParser.MulDivContext;
import com.amarsoft.app.base.antlr.OQLParser.NullContext;
import com.amarsoft.app.base.antlr.OQLParser.NumberContext;
import com.amarsoft.app.base.antlr.OQLParser.ParameterContext;
import com.amarsoft.app.base.antlr.OQLParser.Paren2Context;
import com.amarsoft.app.base.antlr.OQLParser.ParenContext;
import com.amarsoft.app.base.antlr.OQLParser.StringContext;
import com.amarsoft.app.base.antlr.OQLParser.SubExprContext;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.base.script.operater.CompareOperator;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;

public class BusinessObjectMatchVisitor extends AbstractParseTreeVisitor<Object> implements OQLVisitor<Object> {
	private BusinessObject businessObject;
	private Map<String,Object> inputParameters;
	private ALSException e=null;
	
	public Object visit(@NotNull ParseTree tree) {
		return tree.accept(this);
	}
	
	public BusinessObjectMatchVisitor(BusinessObject businessObject,Map<String,Object> inputParameters){
		this.businessObject=businessObject;
		this.inputParameters=inputParameters;
	}

	@Override
	public Object visitLogicalAndOr(LogicalAndOrContext ctx) {
		Boolean left = (Boolean)visit(ctx.equality_expression(0)); 
		Equality_expressionContext r = ctx.equality_expression(1);
		Boolean right = (Boolean)visit(r);

        if (ctx.op.getType() == OQLParser.LOGICAL_AND) { 
            return left && right; 
        }
        if (ctx.op.getType() == OQLParser.LOGICAL_OR) { 
        	return left || right; 
        }
        else return true;
	}

	@Override
	public Object visitLogicalFalse(LogicalFalseContext ctx) {
		return false;
	}

	@Override
	public Object visitAttribute(AttributeContext ctx) {
		String varName=ctx.getText();
		Object o=null;
		try{
			o=businessObject.getObject(varName);
		}
		catch(Exception e){
			if(this.e==null){
				try{
					this.e=new ALSException("EC9997");
				}catch(Exception ex){
					ex.printStackTrace();
				}
			}
		}
		return o;
	}
	
	@Override
	public Object visitParameter(ParameterContext ctx) {
		String varName=ctx.getText();
		varName=varName.substring(1);
		Object o=null;
		try{
			o=inputParameters.get(varName);
		}
		catch(Exception e){
			if(this.e==null){
				try{
					this.e=new ALSException("EC9997");
				}catch(Exception ex){
					ex.printStackTrace();
				}
			}
		}
		return o;
	}

	@Override
	public Object visitNumber(NumberContext ctx) {
		String d=ctx.NUMBER().getText();
		return Double.parseDouble(d);
	}

	@Override
	public Object visitMulDiv(MulDivContext ctx) {
		double left = (Double)visit(ctx.expression(0)); 
        double right = (Double)visit(ctx.expression(1));

        if (ctx.op.getType() == OQLParser.MUL) { 
            return left * right; 
        }
        if (ctx.op.getType() == OQLParser.DIV) { 
        	return left / right; 
        }
        else{
        	return new Double(Double.NaN);
        }
	}

	@Override
	public Object visitAddSub(AddSubContext ctx) {
		double left = (Double)visit(ctx.expression(0)); 
        double right = (Double)visit(ctx.expression(1));
        if (ctx.op.getType() == OQLParser.ADD) { 
            return left + right; 
        }
        if (ctx.op.getType() == OQLParser.SUB) { 
        	return left - right; 
        }
        else{
        	return new Double(Double.NaN);
        }
	}

	@Override
	public Object visitSubExpr(SubExprContext ctx) {
		Object o=visit(ctx.expression());
		return o;
	}

	@Override
	public Object visitParen2(Paren2Context ctx) {
		Object o=visit(ctx.equality_expression());
		return o;
	}

	@Override
	public Object visitLogicalCompare(LogicalCompareContext ctx) {
		Object left=visit(ctx.expression(0)); 
		Object right=visit(ctx.expression(1));
		String operator=ctx.op.getText();
		if(right instanceof String){
			String s=(String)right;
			if(s.startsWith("'")&&s.endsWith("'")){
				s=s.substring(1,s.length()-1);
			}
			right=s;
		}
		
		try{
			CompareOperator c=ScriptConfig.getCompareOperator(operator);
			return c.compare(left, right);
		}
		catch(Exception e){
			e.printStackTrace();
			if(this.e==null){
				this.e=new ALSException("EC9997");
				this.e.addSuppressed(e);
			}
			return -1;
		}
		
	}

	@Override
	public Object visitString(StringContext ctx) {
		String s=ctx.getText();
		return s;
	}

	@Override
	public Object visitLogicalTrue(LogicalTrueContext ctx) {
		return true;
	}

	@Override
	public Object visitParen(ParenContext ctx) {
		Object o=visit(ctx.expression());
		return o;
	}

	@Override
	public Object visitLogicalIn(LogicalInContext ctx) {
		Object left=visit(ctx.expression(0)); 
		Object right=visit(ctx.expression(1));
		if(left==null) return false;
			
		if(right instanceof String[]){
			String[] array=(String[])right;
			for(String s:array){
				if(left.equals(s)) return true;
			}
		}
		else if(right instanceof String){
			String[] array=((String)right).split(",");
			for(String s:array){
				if(left.equals(s) || ("'"+left+"'").equals(s) || ("'"+left).equals(s) || (left+"'").equals(s)) return true;
			}
		}
		return false;
	}

	@Override
	public Object visitArrayExpr(ArrayExprContext ctx) {
		List<TerminalNode> strings = ctx.STRING();
		String[] array=new String[strings.size()];
		for(int i=0;i<strings.size();i++){
			String s=ctx.STRING(i).getText(); 
			array[i]=s.substring(1, s.length()-1);
		}
		return array;
	}

	@Override
	public Object visitNull(NullContext ctx) {
		return null;
	}

	@Override
	public Object visitLogicalLength(LogicalLengthContext ctx) {
		Object value=visit(ctx.expression()); 
		if(value==null) return 0;
		else return value.toString().length();
	}

	@Override
	public Object visitLogicalMonth(LogicalMonthContext ctx){
		String beginDate =  (String)visit(ctx.expression(0));
		String endDate =  (String)visit(ctx.expression(1));
		
		try
		{
			return Math.ceil(DateHelper.getMonths(beginDate, endDate));
		}catch(Exception ex){
			ARE.getLog().error("日期传入错误【"+beginDate+"-"+endDate+"】。");
			ex.printStackTrace();
			return -1;
		}
	}
}
