// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "OW2Hair"
{
	Properties
	{
		[Space(5)][Header(__________OW2 Hair Shader by DarkBlade909 v0.2 (WIP)__________)]_MainTex("Albedo", 2D) = "white" {}
		[Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0.5
		_HairAO("Hair AO", 2D) = "white" {}
		_Emission("Emission", 2D) = "black" {}
		_EmissionIntensity("Emission Intensity", Float) = 1
		_Anisotropy("Anisotropy", Range( 0 , 1)) = 0
		_Anisotropicgloss("Anisotropic gloss", Range( 0 , 1)) = 0.5
		_StrandMap("Strand Map", 2D) = "gray" {}
		_Strand("Strand", 2D) = "black" {}
		_HairDensity("Hair Density", Float) = 10
		_Roughness1("Roughness 1", Range( 0 , 1)) = 1
		_Roughness2("Roughness 2", Range( 0 , 1)) = 1
		_Roughness3("Roughness 3", Range( 0 , 1)) = 1
		_Detail1("Detail 1", Range( 0 , 1)) = 0.15
		_Detail2("Detail 2", Range( 0 , 1)) = 0.5
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 uv2_texcoord2;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalMap);
		uniform float4 _NormalMap_ST;
		SamplerState sampler_NormalMap;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
		uniform float4 _MainTex_ST;
		SamplerState sampler_MainTex;
		uniform float _Anisotropicgloss;
		uniform float _Anisotropy;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Emission);
		uniform float4 _Emission_ST;
		SamplerState sampler_Emission;
		uniform float _EmissionIntensity;
		uniform float _Metallic;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Strand);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_StrandMap);
		uniform float4 _StrandMap_ST;
		SamplerState sampler_point_repeat;
		uniform float _HairDensity;
		SamplerState sampler_Strand;
		SamplerState sampler_StrandMap;
		uniform float _Roughness1;
		uniform float _Detail1;
		uniform float _Detail2;
		uniform float _Roughness2;
		uniform float _Roughness3;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_HairAO);
		uniform float4 _HairAO_ST;
		SamplerState sampler_HairAO;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode5 = UnpackNormal( SAMPLE_TEXTURE2D( _NormalMap, sampler_NormalMap, uv_NormalMap ) );
			float3 Normal19 = tex2DNode5;
			o.Normal = Normal19;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, uv_MainTex );
			float3 newWorldNormal6_g26 = (WorldNormalVector( i , ( tex2DNode5 * float3( 2,2,1 ) ) ));
			float3 normalizeResult3_g26 = normalize( newWorldNormal6_g26 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult4_g28 = normalize( ( ase_worldViewDir + ( ase_worldlightDir < float3( -1,-1,-1 ) ? float3(0,0.5,1) : ase_worldlightDir ) ) );
			float3 temp_output_44_0_g26 = normalizeResult4_g28;
			float dotResult27_g26 = dot( normalizeResult3_g26 , temp_output_44_0_g26 );
			float temp_output_32_0_g26 = max( dotResult27_g26 , 0.0 );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float dotResult13_g26 = dot( temp_output_44_0_g26 , ase_worldTangent );
			float temp_output_20_0_g26 = ( 1.0 - (0.5 + (_Anisotropicgloss - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) );
			float temp_output_21_0_g26 = ( temp_output_20_0_g26 * temp_output_20_0_g26 );
			half2 _half = half2(1,0.9);
			float temp_output_18_0_g26 = sqrt( ( _half.x - ( _Anisotropy * _half.y ) ) );
			float temp_output_38_0_g26 = ( max( ( temp_output_21_0_g26 / temp_output_18_0_g26 ) , 0.001 ) * 5 );
			float temp_output_28_0_g26 = ( dotResult13_g26 / temp_output_38_0_g26 );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float dotResult14_g26 = dot( temp_output_44_0_g26 , ase_worldBitangent );
			float temp_output_39_0_g26 = ( max( ( temp_output_18_0_g26 * temp_output_21_0_g26 ) , 0.001 ) * 5 );
			float temp_output_33_0_g26 = ( dotResult14_g26 / temp_output_39_0_g26 );
			float temp_output_36_0_g26 = ( ( temp_output_32_0_g26 * temp_output_32_0_g26 ) + ( temp_output_28_0_g26 * temp_output_28_0_g26 ) + ( temp_output_33_0_g26 * temp_output_33_0_g26 ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 Albedo18 = saturate( ( tex2DNode1 + ( tex2DNode1 * ( 1.0 / ( ( temp_output_36_0_g26 * temp_output_36_0_g26 ) * temp_output_38_0_g26 * temp_output_39_0_g26 * UNITY_PI ) ) * _Anisotropy * ase_lightColor ) ) );
			o.Albedo = Albedo18.rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 Emission99 = ( SAMPLE_TEXTURE2D( _Emission, sampler_Emission, uv_Emission ) * _EmissionIntensity );
			o.Emission = Emission99.rgb;
			o.Metallic = _Metallic;
			float2 uv_StrandMap = i.uv_texcoord * _StrandMap_ST.xy + _StrandMap_ST.zw;
			float2 temp_output_3_0_g25 = ( ( 2.0 * UNITY_PI ) * (SAMPLE_TEXTURE2D( _StrandMap, sampler_point_repeat, uv_StrandMap )).rg );
			float2 temp_output_8_0_g25 = cos( temp_output_3_0_g25 );
			float2 temp_output_14_0_g25 = ( ( i.uv_texcoord - float2( 0.5,0.5 ) ) * float2( 1,-1 ) );
			float temp_output_17_0_g25 = (temp_output_14_0_g25).x;
			float2 temp_output_7_0_g25 = sin( temp_output_3_0_g25 );
			float3 temp_output_11_0_g25 = ( (temp_output_7_0_g25).xxy * (temp_output_14_0_g25).yxy );
			float2 break30_g25 = ( ( temp_output_8_0_g25 * temp_output_17_0_g25 ) - (temp_output_11_0_g25).xz );
			float2 appendResult25_g25 = (float2((temp_output_11_0_g25).y , ( (temp_output_7_0_g25).y * temp_output_17_0_g25 )));
			float2 break31_g25 = ( appendResult25_g25 + ( temp_output_8_0_g25 * (temp_output_14_0_g25).y ) );
			float3 appendResult32_g25 = (float3(break30_g25.x , break31_g25.x , break30_g25.y));
			float temp_output_2_0_g25 = _HairDensity;
			float3 temp_output_36_0_g25 = ( ( appendResult32_g25 + float3( 0.5,0.5,0.5 ) ) * temp_output_2_0_g25 );
			float2 appendResult37_g25 = (float2((temp_output_36_0_g25).z , ( temp_output_2_0_g25 * ( break31_g25.y + 0.5 ) )));
			float2 temp_output_9_0_g29 = (SAMPLE_TEXTURE2D( _Strand, sampler_Strand, appendResult37_g25 )).rg;
			float2 break12_g29 = ( (( (SAMPLE_TEXTURE2D( _Strand, sampler_Strand, (temp_output_36_0_g25).xy )).rg - temp_output_9_0_g29 )*SAMPLE_TEXTURE2D( _StrandMap, sampler_StrandMap, uv_StrandMap ).a + temp_output_9_0_g29) - float2( 1,0.5 ) );
			float Rough83 = saturate( ( pow( ( (break12_g29.x*( SAMPLE_TEXTURE2D( _StrandMap, sampler_StrandMap, uv_StrandMap ).a * _Roughness1 ) + 1.0) * _Detail1 ) , _Detail2 ) + ( pow( abs( break12_g29.y ) , _Roughness2 ) * _Roughness3 * SAMPLE_TEXTURE2D( _StrandMap, sampler_StrandMap, uv_StrandMap ).a ) ) );
			o.Smoothness = Rough83;
			float2 uv_HairAO = i.uv_texcoord * _HairAO_ST.xy + _HairAO_ST.zw;
			float4 tex2DNode13 = SAMPLE_TEXTURE2D( _HairAO, sampler_HairAO, uv_HairAO );
			float AO22 = tex2DNode13.r;
			o.Occlusion = AO22;
			o.Alpha = SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, i.uv2_texcoord2 ).a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
0;616;1428;423;2061.741;-33.48689;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;92;-1336.819,771.0403;Inherit;False;1967.899;995.889;;15;81;66;76;67;83;85;78;80;79;77;86;90;89;88;87;Strand Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerStateNode;67;-1322.03,1497.71;Inherit;False;0;0;0;0;-1;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1610.462,-292.3116;Inherit;False;Property;_Anisotropicgloss;Anisotropic gloss;10;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1653.108,-554.7003;Inherit;True;Property;_NormalMap;Normal Map;3;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1296.857,-548.6203;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;2,2,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;93;-1313.043,-305.0769;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;-1118.897,1444.218;Inherit;True;Property;_StrandMap;Strand Map;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-1613.079,-367.999;Inherit;False;Property;_Anisotropy;Anisotropy;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-986.6461,1635.439;Inherit;False;Property;_HairDensity;Hair Density;14;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;65;-835.8847,-302.334;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;95;-851.1647,-361.2131;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1113.03,-722.5962;Inherit;True;Property;_MainTex;Albedo;1;0;Create;False;0;0;0;False;2;Space(5);Header(__________OW2 Hair Shader by DarkBlade909 v0.2 (WIP)__________);False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;81;-720.6365,1506.659;Inherit;False;OW2StrandPreprocess;-1;;25;2f2d1e0ba560c394f9d91f9a81a23982;0;2;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;2;FLOAT2;0;FLOAT2;42
Node;AmplifyShaderEditor.FunctionNode;24;-1112.657,-531.468;Inherit;False;Trowbridge-Reitz Aniso NDF;-1;;26;2a680a5d45b292544abf41ca00dae14a;2,7,0,2,0;7;1;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;44;FLOAT3;0,0,0;False;45;FLOAT3;0,0,0;False;46;FLOAT3;0,0,0;False;15;FLOAT;1;False;19;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;79;-404.2382,1192.565;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;gray;Auto;False;Instance;66;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;88;-400.1122,963.7711;Inherit;False;Property;_Roughness3;Roughness 3;17;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-403.4843,1575.058;Inherit;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;77;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;90;-399.1122,1107.771;Inherit;False;Property;_Detail2;Detail 2;19;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-400.1122,1034.771;Inherit;False;Property;_Detail1;Detail 1;18;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-400.1122,891.7709;Inherit;False;Property;_Roughness2;Roughness 2;16;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;-405.2401,1384.916;Inherit;True;Property;_Strand;Strand;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;-401.2821,819.489;Inherit;False;Property;_Roughness1;Roughness 1;15;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-658.9927,-554.4874;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;96;-1650.965,79.77275;Inherit;True;Property;_Emission;Emission;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;78;-46.66315,1077.908;Inherit;False;OW2StrandMap;-1;;29;1d3a70e8cf0e4be429e192a8676ff633;0;8;14;FLOAT;0.5;False;15;FLOAT;0.5;False;16;FLOAT;0.5;False;22;FLOAT;0;False;23;FLOAT;0;False;1;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-512.1893,-606.4615;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-1649.869,278.7065;Inherit;False;Property;_EmissionIntensity;Emission Intensity;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;85;248.2929,1082.306;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;62;-376.8376,-606.54;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1305.827,209.7065;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-912.4094,91.49995;Inherit;True;Property;_HairAO;Hair AO;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-336.1893,272.1905;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-1157.827,209.7065;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-1298.353,-453.0599;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-603.5469,77.06779;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;440.7272,1076.194;Inherit;False;Rough;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-233.1431,-611.2702;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;16;-484.6227,169.8982;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-43.27181,185.3335;Inherit;False;22;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;72;-323.7329,502.7598;Inherit;False;Property;_Keyword0;Keyword 0;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-340.9192,-6.813389;Inherit;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-536.7329,494.7598;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-603.6227,170.8982;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-576.8125,0.5761414;Inherit;False;83;Rough;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-1334.571,-134.8511;Inherit;False;Tangent;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-4.555377,89.18967;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-341.7758,83.03219;Inherit;False;Property;_Gloss;Gloss;2;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-1651.258,-134.5384;Inherit;True;Property;_TangentMap;Tangent Map;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;100;-42.76044,-20.43549;Inherit;False;99;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-46.94172,-167.542;Inherit;False;18;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-45.13446,-92.78519;Inherit;False;19;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-105.3232,504.0171;Inherit;False;_ZWrite;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-131.7291,270.7533;Inherit;True;Property;_MainTex1;Albedo;1;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;-537.7329,564.7598;Inherit;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;250.2541,-6.825111;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;OW2Hair;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;57;0;5;0
WireConnection;93;0;31;0
WireConnection;66;7;67;0
WireConnection;95;0;32;0
WireConnection;81;1;66;0
WireConnection;81;2;76;0
WireConnection;24;1;57;0
WireConnection;24;15;32;0
WireConnection;24;19;93;0
WireConnection;80;1;81;42
WireConnection;77;1;81;0
WireConnection;26;0;1;0
WireConnection;26;1;24;0
WireConnection;26;2;95;0
WireConnection;26;3;65;0
WireConnection;78;14;86;0
WireConnection;78;15;87;0
WireConnection;78;16;88;0
WireConnection;78;22;89;0
WireConnection;78;23;90;0
WireConnection;78;1;79;0
WireConnection;78;3;77;0
WireConnection;78;6;80;0
WireConnection;25;0;1;0
WireConnection;25;1;26;0
WireConnection;85;0;78;0
WireConnection;62;0;25;0
WireConnection;98;0;96;0
WireConnection;98;1;97;0
WireConnection;99;0;98;0
WireConnection;19;0;5;0
WireConnection;22;0;13;1
WireConnection;83;0;85;0
WireConnection;18;0;62;0
WireConnection;16;0;15;0
WireConnection;72;1;73;0
WireConnection;72;0;74;0
WireConnection;15;0;13;2
WireConnection;15;1;13;3
WireConnection;30;0;29;0
WireConnection;17;0;4;0
WireConnection;17;1;16;0
WireConnection;70;0;72;0
WireConnection;2;1;3;0
WireConnection;0;0;20;0
WireConnection;0;1;21;0
WireConnection;0;2;100;0
WireConnection;0;3;12;0
WireConnection;0;4;84;0
WireConnection;0;5;23;0
WireConnection;0;9;2;4
ASEEND*/
//CHKSM=1839ACCDD0E0E1440940A72004A487C1A2926928