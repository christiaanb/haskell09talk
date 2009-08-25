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
\subsection{Mealy Machine}
\frame
{
\frametitle{Mealy Machine}
  \begin{figure}
  \centerline{\includegraphics[width=\textwidth]{mealymachine}}
  \label{img:mealymachine}
  \end{figure}
}

\frame
{
\frametitle{Haskell Description}
\begin{code}
mealyMachine :: 
  InputSignals ->
  {-"{\color<2->[rgb]{1,0,0}"-}State{-"}"-} ->
  (State, OutputSignals)
mealyMachine inputs {-"{\color<2->[rgb]{1,0,0}"-}state{-"}"-} = ({-"{\color<3->[rgb]{0,0,1}"-}new_state{-"}"-}, output)
  where
    {-"{\color<3->[rgb]{0,0,1}"-}new_state{-"}"-}   =   logic     {-"{\color<2->[rgb]{1,0,0}"-}state{-"}"-}   input
    outputs                                         =   logic     {-"{\color<2->[rgb]{1,0,0}"-}state{-"}"-}   input
\end{code}
}
\subsection{Simulation}
\frame
{
\frametitle{Simulating a Mealy Machine}
\begin{code}
run func {-"{\color<2->[rgb]{1,0,0}"-}state{-"}"-} [] = []
run func {-"{\color<2->[rgb]{1,0,0}"-}state{-"}"-} (i:input) = o:out
  where
    ({-"{\color<3->[rgb]{0,0,1}"-}state'{-"}"-}, o) = func {-"{\color<2->[rgb]{1,0,0}"-}state{-"}"-} i
    out         = run func {-"{\color<3->[rgb]{0,0,1}"-}state'{-"}"-} input
\end{code}
}