%include talk.fmt
\section{Introduction}
\subsection{What will you see}
\frame
{
  \frametitle{What will we see?}
  \begin{itemize}
    \item Small tour: what can we describe in \clash{}
    \item Quick real demo
  \end{itemize}
}
\note{Virtuele demo}

\subsection{What is \texorpdfstring{\clash{}}{CLasH}}
\frame
{
  \frametitle{What is \clash{}?}
  \begin{itemize}
    \item \clash{}: CAES Language for Hardware Descriptions
    \item Rapid prototyping language
    \item Subset of Haskell can be translated to Hardware (VHDL)
    \item Structural Description of a Mealy Machine
  \end{itemize}
}
\note[itemize]
{
\item Wij zijn wij
\item \clash{} voor rapid prototyping
\item Subset haskell vertaalbaar
\item Mealy machine beschrijving
}

\subsection{Mealy Machine}
\frame
{
\frametitle{Mealy Machine}
  \begin{figure}
  \centerline{\includegraphics[width=10cm]{mealymachine}}
  \label{img:mealymachine}
  \end{figure}
}
\note{
Voor wie het niet meer weet, dit is een mealy machine
}

\frame
{
\frametitle{Haskell Description}
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
mealyMachine :: 
  InputSignals ->
  {-"{\color<2>[rgb]{1,0,0}"-}State{-"}"-} ->
  (State, OutputSignals)
mealyMachine inputs {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-} = ({-"{\color<3>[rgb]{1,0,0}"-}new_state{-"}"-}, output)
  where
    {-"{\color<3>[rgb]{1,0,0}"-}new_state{-"}"-}    =   logic     {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-}   input
    outputs                                         =   logic     {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-}   input
\end{code}
\end{beamercolorbox}
}
\subsection{Simulation}
\frame
{
\frametitle{Simulating a Mealy Machine}
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
run func {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-} [] = []
run func {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-} (i:input) = o:out
  where
    ({-"{\color<3>[rgb]{1,0,0}"-}state'{-"}"-}, o)  =   func i {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-}
    out                                             =   run func {-"{\color<3>[rgb]{1,0,0}"-}state'{-"}"-} input
\end{code}
\end{beamercolorbox}
}