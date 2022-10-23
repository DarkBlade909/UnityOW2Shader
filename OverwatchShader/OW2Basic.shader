// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "OW2Basic"
{
	Properties
	{
		[NoScaleOffset][Header(__________OW2 Basic Shader by DarkBlade909 v0.2 (WIP)__________)][Space(5)]_MainTex("Albedo", 2D) = "white" {}
		[NoScaleOffset]_PBR("PBR", 2D) = "gray" {}
		[NoScaleOffset][Normal]_BumpMap("Normal Map", 2D) = "bump" {}
		[NoScaleOffset]_Emission("Emission Map", 2D) = "black" {}
		[NoScaleOffset]_Occlusion("Ambient Occlusion", 2D) = "white" {}
		_EmissionStrength1("Emission Strength", Float) = 1
		[NoScaleOffset]_Opacity("Opacity Map", 2D) = "white" {}
		_CutoutClipping("Cutout Clipping", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);
		SamplerState sampler_linear_repeat;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Emission);
		uniform float _EmissionStrength1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_PBR);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Occlusion);
		SamplerState sampler_Occlusion;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Opacity);
		uniform float _CutoutClipping;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap12 = i.uv_texcoord;
			float3 NormalMap13 = UnpackNormal( SAMPLE_TEXTURE2D( _BumpMap, sampler_linear_repeat, uv_BumpMap12 ) );
			o.Normal = NormalMap13;
			float2 uv_MainTex14 = i.uv_texcoord;
			float4 Albedo16 = SAMPLE_TEXTURE2D( _MainTex, sampler_linear_repeat, uv_MainTex14 );
			o.Albedo = Albedo16.rgb;
			float2 uv_Emission21 = i.uv_texcoord;
			float4 finalEmission26 = ( SAMPLE_TEXTURE2D( _Emission, sampler_linear_repeat, uv_Emission21 ) * Albedo16 * _EmissionStrength1 );
			o.Emission = finalEmission26.rgb;
			float2 uv_PBR3 = i.uv_texcoord;
			float4 tex2DNode3 = SAMPLE_TEXTURE2D( _PBR, sampler_linear_repeat, uv_PBR3 );
			float clampResult9 = clamp( ( ( ( step( 0.525 , tex2DNode3.r ) * tex2DNode3.r ) - 0.5 ) * 2.0 ) , 0.0 , 1.0 );
			float Metallic10 = clampResult9;
			o.Metallic = Metallic10;
			float Gloss8 = tex2DNode3.g;
			o.Smoothness = Gloss8;
			float2 uv_Occlusion35 = i.uv_texcoord;
			float4 AO27 = SAMPLE_TEXTURE2D( _Occlusion, sampler_Occlusion, uv_Occlusion35 );
			o.Occlusion = AO27.r;
			o.Alpha = 1;
			float2 uv_Opacity22 = i.uv_texcoord;
			float4 Opacity25 = SAMPLE_TEXTURE2D( _Opacity, sampler_linear_repeat, uv_Opacity22 );
			clip( Opacity25.r - _CutoutClipping );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
267;404;1573;507;2095.836;268.5703;1.633588;True;False
Node;AmplifyShaderEditor.SamplerStateNode;1;-2669.662,55.17124;Inherit;False;0;0;0;1;-1;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.WireNode;2;-2384.896,-81.12884;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerNode;3;-2256.896,-257.1288;Inherit;True;Property;_PBR;PBR;1;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;4;-1904.896,-305.1288;Inherit;False;2;0;FLOAT;0.525;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1776.896,-241.1289;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-2256.896,-1.128841;Inherit;True;Property;_MainTex;Albedo;0;1;[NoScaleOffset];Create;False;0;0;0;False;2;Header(__________OW2 Basic Shader by DarkBlade909 v0.2 (WIP)__________);Space(5);False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1952.896,-1.128841;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-1648.896,-257.1288;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;15;-2422.026,459.0854;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2174.248,686.5787;Inherit;False;Property;_EmissionStrength1;Emission Strength;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1504.896,-257.1288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;18;-2432.896,-337.1288;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerNode;21;-2270.248,414.5783;Inherit;True;Property;_Emission;Emission Map;3;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;20;-2142.248,606.5787;Inherit;False;16;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;11;-2409.935,271.8491;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1886.248,494.5786;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;22;-2256.896,-513.1288;Inherit;True;Property;_Opacity;Opacity Map;6;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;9;-1376.896,-257.1288;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-2270.248,222.5784;Inherit;True;Property;_BumpMap;Normal Map;2;2;[NoScaleOffset];[Normal];Create;False;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-2267.715,774.8102;Inherit;True;Property;_Occlusion;Ambient Occlusion;4;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1758.248,494.5786;Inherit;False;finalEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1920.896,-145.1288;Inherit;False;Gloss;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1951.972,776.0113;Inherit;False;AO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-1936.896,-513.1288;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1232.896,-257.1288;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1966.248,219.908;Inherit;False;NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-237.0424,427.4198;Inherit;False;Property;_CutoutClipping;Cutout Clipping;7;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-239.5735,111.1133;Inherit;False;10;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-244.4609,-127.7719;Inherit;False;16;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-244.5735,188.1133;Inherit;False;8;Gloss;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-253.7685,-47.55672;Inherit;False;13;NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-260.8616,34.55799;Inherit;False;26;finalEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-240.5735,266.1133;Inherit;False;27;AO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-240.2317,338.1927;Inherit;False;25;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1.633588,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;OW2Basic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;True;36;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;3;7;2;0
WireConnection;4;1;3;1
WireConnection;5;0;4;0
WireConnection;5;1;3;1
WireConnection;14;7;1;0
WireConnection;16;0;14;0
WireConnection;6;0;5;0
WireConnection;15;0;1;0
WireConnection;7;0;6;0
WireConnection;18;0;1;0
WireConnection;21;7;15;0
WireConnection;11;0;1;0
WireConnection;23;0;21;0
WireConnection;23;1;20;0
WireConnection;23;2;17;0
WireConnection;22;7;18;0
WireConnection;9;0;7;0
WireConnection;12;7;11;0
WireConnection;26;0;23;0
WireConnection;8;0;3;2
WireConnection;27;0;35;0
WireConnection;25;0;22;0
WireConnection;10;0;9;0
WireConnection;13;0;12;0
WireConnection;0;0;28;0
WireConnection;0;1;34;0
WireConnection;0;2;29;0
WireConnection;0;3;30;0
WireConnection;0;4;33;0
WireConnection;0;5;31;0
WireConnection;0;10;32;0
ASEEND*/
//CHKSM=C4A2360B477F429DCE1D7C1C5105B8581ABE2AD3